
clc;
clear;
close all;

SNR_dB = 0:2:20;

BER_SISO = zeros(size(SNR_dB));
BER_MIMO = zeros(size(SNR_dB));

for k = 1:length(SNR_dB)

    N = 10000;
    bits = randi([0 1], N, 1);
    tx = 2 * bits - 1;

    snrLin = 10^(SNR_dB(k) / 10);

    % SISO System
    noise = randn(N, 1) / sqrt(2 * snrLin);
    rx = tx + noise;
    bits_hat = real(rx) > 0;

    BER_SISO(k) = mean(bits_hat ~= bits);

    % Simple 2x2 MIMO Equivalent Link
    H = (randn(2,2) + 1j * randn(2,2)) / sqrt(2);
    h_eff = sqrt(sum(abs(H(:)).^2) / 2);

    noise2 = randn(N, 1) / sqrt(2 * snrLin);
    rx2 = h_eff * tx + noise2;
    bits_hat2 = real(rx2) > 0;

    BER_MIMO(k) = mean(bits_hat2 ~= bits);

end

% Plot BER Performance
figure;

semilogy(SNR_dB, BER_SISO, 'o-', 'LineWidth', 2);
hold on;

semilogy(SNR_dB, BER_MIMO, 's-', 'LineWidth', 2);

grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('SISO and MIMO BER Performance');

legend('SISO', 'MIMO');
