
clc;
clear;
close all;

scs = [15 30 60 120 240];       % Subcarrier spacing (kHz)
mu = 0:4;                       % Numerology index
slot = [1 0.5 0.25 0.125 0.0625]; % Slot duration (ms)

% Plot Slot Duration
figure;

plot(scs, slot, 'o-', 'LineWidth', 2);

grid on;
xlabel('Subcarrier Spacing (kHz)');
ylabel('Slot Duration (ms)');
title('5G NR Slot Duration for Different Subcarrier Spacing');

% Plot Subcarrier Spacing
figure;

bar(scs);

grid on;
set(gca, 'XTickLabel', mu);

xlabel('Numerology Index (\mu)');
ylabel('Subcarrier Spacing (kHz)');
title('5G NR Subcarrier Spacing for Different Numerologies');
