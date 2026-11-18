
clc;
clear;
close all;

%% 1. Input Parameters Setup
N = 64;                  % Total subcarriers
M = 12;                  % Active subcarriers
N_cp = 16;               % Cyclic prefix for OFDM
K_fbmc = 4;              % FBMC overlapping factor
N_sym = 100;             % Number of symbols

rng(42);                 % Reproducible results

% Active subcarrier index allocation
active_idx = (N/2 - M/2 + 1):(N/2 + M/2);

%% 2. Data Generation and QAM Mapping
num_bits_per_sym = M * 2;    % 4-QAM = 2 bits/symbol

data_bits = randi([0 1], num_bits_per_sym, N_sym);

% Modulate bits to QAM symbols
qam_mod = zeros(M, N_sym);

for s = 1:N_sym

    bits = data_bits(:, s);

    for m = 1:M

        b_idx = (m-1)*2 + 1;

        % Simple QAM Gray Mapping
        real_part = 1 - 2*bits(b_idx);
        imag_part = 1 - 2*bits(b_idx+1);

        qam_mod(m, s) = (real_part + 1i*imag_part)/sqrt(2);

    end
end

%% 3. OFDM Waveform Generation
ofdm_tx_sig = [];

for s = 1:N_sym

    ifft_in = zeros(N, 1);
    ifft_in(active_idx) = qam_mod(:, s);

    time_sym = ifft(ifft_in) * sqrt(N);

    % Append Cyclic Prefix
    cp_part = time_sym(end-N_cp+1:end);

    ofdm_tx_sig = [ofdm_tx_sig; cp_part; time_sym];

end

%% 4. FBMC Waveform Generation (OQAM Processing)

% PHYDYAS Prototype Filter Coefficients for K=4
H1 = 0.97195983;
H2 = 0.70710678;
H3 = 0.23514752;

g = zeros(1, 4*N);

for t = 0:(4*N-1)

    g(t+1) = 1 ...
        - 2*H1*cos(2*pi*t/(4*N)) ...
        + 2*H2*cos(4*pi*t/(4*N)) ...
        - 2*H3*cos(6*pi*t/(4*N));

end

g = g / sqrt(sum(g.^2));

fbmc_tx_sig = zeros(N*N_sym + 4*N, 1);

% OQAM Implementation
for s = 1:N_sym

    for m = 1:M

        k = active_idx(m);
        sym_data = qam_mod(m, s);

        % In-phase and Quadrature components
        r_data = real(sym_data);
        i_data = imag(sym_data);

        % Phase tracking offsets
        phase_r = exp(1i*pi*(k-1)*(0-(4-1)/2));

        phase_i = exp(1i*pi*(k-1)*(N/2-(4-1)/2))*1i;

        % Time domain modulation
        t_arr = 0:(4*N-1);

        carrier_r = exp(1i*2*pi*(k-1)*t_arr/N)*phase_r;
        carrier_i = exp(1i*2*pi*(k-1)*t_arr/N)*phase_i;

        % Time shifting
        shift_r = (s-1)*N + 1;
        shift_i = (s-1)*N + N/2 + 1;

        fbmc_tx_sig(shift_r:shift_r+4*N-1) = ...
            fbmc_tx_sig(shift_r:shift_r+4*N-1) + ...
            (r_data*g.*carrier_r).';

        fbmc_tx_sig(shift_i:shift_i+4*N-1) = ...
            fbmc_tx_sig(shift_i:shift_i+4*N-1) + ...
            (i_data*g.*carrier_i).';

    end
end

%% 5. Metric Calculations (PAPR)

window_len_ofdm = N + N_cp;

ofdm_papr_vals = zeros(N_sym, 1);

for s = 1:N_sym

    seg = ofdm_tx_sig((s-1)*window_len_ofdm+1 : ...
        s*window_len_ofdm);

    ofdm_papr_vals(s) = max(abs(seg).^2) / mean(abs(seg).^2);

end

max_ofdm_papr = 10*log10(max(ofdm_papr_vals));

fbmc_papr_vals = zeros(N_sym, 1);

for s = 1:N_sym

    seg = fbmc_tx_sig((s-1)*N+1 : (s-1)*N+N);

    if mean(abs(seg).^2) > 0

        fbmc_papr_vals(s) = ...
            max(abs(seg).^2) / mean(abs(seg).^2);

    end
end

max_fbmc_papr = 10*log10(max(fbmc_papr_vals));

%% 6. Display Performance Metrics
fprintf('\nWAVEFORM COMPARISON SIMULATION RESULTS\n');
fprintf('=======================================\n');

fprintf('OFDM Max Inst. PAPR : %.3f dB\n', max_ofdm_papr);
fprintf('FBMC Max Inst. PAPR : %.3f dB\n', max_fbmc_papr);

%% 7. Plotting Power Spectral Density (PSD)

[psd_ofdm, f_ofdm] = periodogram(ofdm_tx_sig, [], 2048, 1, 'centered');

[psd_fbmc, f_fbmc] = periodogram(fbmc_tx_sig, [], 2048, 1, 'centered');

figure('Name', 'Waveform Spectral Evaluation');

plot(f_ofdm, 10*log10(psd_ofdm/max(psd_ofdm)), ...
    'r-', 'LineWidth', 1.2);

hold on;

plot(f_fbmc, 10*log10(psd_fbmc/max(psd_fbmc)), ...
    'b-', 'LineWidth', 1.2);

grid on;

xlabel('Normalized Frequency (\times \pi rad/sample)');
ylabel('Relative Power Density (dB)');

title('PSD Comparison: OFDM vs. FBMC');

legend('OFDM (Rectangular Window)', ...
    'FBMC (PHYDYAS Prototype Filter)', ...
    'Location', 'southoutside');

ylim([-80 5]);
