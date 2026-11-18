
clc;
clear;
close all;

%% 1. Input Parameters Setup
N_bits = 50000;             % Data length per SNR point
SNR_dB = 0:2:20;             % SNR operating range

alpha1 = 0.75;               % Far user power allocation
alpha2 = 1 - alpha1;         % Near user power allocation

ber_User1 = zeros(length(SNR_dB), 1);
ber_User2 = zeros(length(SNR_dB), 1);
ber_OFDMA = zeros(length(SNR_dB), 1);

%% 2. Data Processing Execution Loops
for s = 1:length(SNR_dB)

    snr_linear = 10^(SNR_dB(s) / 10);
    noise_variance = 1 / snr_linear;

    % Source Bits Generation
    bits_u1 = randi([0 1], N_bits, 1);
    bits_u2 = randi([0 1], N_bits, 1);

    % BPSK Constellation Mapping
    x1 = 2 * bits_u1 - 1;
    x2 = 2 * bits_u2 - 1;

    % Power-Domain NOMA Superposition
    x_noma = sqrt(alpha1) * x1 + sqrt(alpha2) * x2;

    % Multi-User AWGN Channel
    noise = sqrt(noise_variance / 2) * ...
        (randn(N_bits, 1) + 1i * randn(N_bits, 1));

    y_noma = real(x_noma + noise);

    %% 3. User 1 Direct Detection
    dec_u1 = y_noma > 0;
    est_x1 = 2 * dec_u1 - 1;

    ber_User1(s) = sum(bits_u1 ~= dec_u1) / N_bits;

    %% 4. Successive Interference Cancellation (SIC)
    y_sic = y_noma - sqrt(alpha1) * est_x1;

    dec_u2 = y_sic > 0;

    ber_User2(s) = sum(bits_u2 ~= dec_u2) / N_bits;

    %% 5. OFDMA Baseline Evaluation
    y_ofdma = x1 + sqrt(noise_variance * 2) / sqrt(2) ...
        * randn(N_bits, 1);

    dec_ofdma = y_ofdma > 0;

    ber_OFDMA(s) = sum(bits_u1 ~= dec_ofdma) / N_bits;

end

%% 6. Performance Graph
figure('Name', 'NOMA SIC Evaluation Matrix');

semilogy(SNR_dB, ber_User1, 'ro-', 'LineWidth', 1.2);
hold on;

semilogy(SNR_dB, ber_User2, 'bs-', 'LineWidth', 1.2);

semilogy(SNR_dB, ber_OFDMA, 'k--', 'LineWidth', 1.2);

grid on;

xlabel('Channel SNR Scaling Index (dB)');
ylabel('Bit Error Rate (BER)');

title('NOMA Power-Domain Transceiver Performance Chart');

legend('User 1 (Far Node Direct Detection)', ...
       'User 2 (Near Node Post-SIC Detection)', ...
       'Baseline OFDMA Orthogonal Benchmark', ...
       'Location', 'best');
