
clc;
clear;
close all;

Nsc = 24;          % Simplified number of subcarriers
Nsym = 14;         % OFDM symbols per slot

grid = zeros(Nsym, Nsc);

% Simplified Downlink (DL) assignment: Symbols 1-10
grid(1:10, :) = 1;

% Simplified Uplink (UL) assignment: Symbols 11-14
grid(11:14, :) = 2;

% Plot Time-Frequency Resource Grid
figure;

imagesc(grid);

grid on;
xlabel('Subcarrier Index');
ylabel('OFDM Symbol Index');
title('Simplified 5G NR Time-Frequency Resource Grid');

colorbar;
