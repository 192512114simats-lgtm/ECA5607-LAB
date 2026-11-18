
clc;
clear;
close all;

SNR_dB = 0:2:20;

Reliability = zeros(size(SNR_dB));

for k = 1:length(SNR_dB)

    N = 10000;
    bits = randi([0 1], N, 1);
    tx = 2 * bits - 1;

    snrLin = 10^(SNR_dB(k) / 10);

    noise = randn(N, 1) / sqrt(2 * snrLin);
    rx = tx + noise;

    bhat = real(rx) > 0;

    BER = mean(bhat ~= bits);

    Reliability(k) = 1 - BER;

end

% Plot Communication Reliability
figure;

plot(SNR_dB, Reliability, 'o-', 'LineWidth', 2);

grid on;
xlabel('SNR (dB)');
ylabel('Reliability (1-BER)');
title('Communication Reliability vs SNR');
