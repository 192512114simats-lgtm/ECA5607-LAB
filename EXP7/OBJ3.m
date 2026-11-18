
clc;
clear;
close all;

symbols = 1:14;

DL = [1 1 1 1 1 1 1 1 1 1 0 0 0 0];
UL = [0 0 0 0 0 0 0 0 0 0 1 1 1 1];

% Plot Downlink and Uplink Assignment
figure;

plot(symbols, DL, 'o-', 'LineWidth', 2);
hold on;

plot(symbols, UL, 's-', 'LineWidth', 2);

grid on;
xlabel('OFDM Symbol Index');
ylabel('Allocation Status');
title('Simplified Downlink and Uplink Assignment');

legend('Downlink', 'Uplink');
