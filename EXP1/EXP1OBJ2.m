
% CDMA SIR Analysis

clear;
clc;
close all;

% System parameters
processingGain = 64;
targetSIRdB = 7;

% Number of simultaneous users
K = 2:30;

% Calculate SIR
sirLinear = processingGain ./ (K - 1);
sirDb = 10 * log10(sirLinear);

% Display results
results = table(K', sirDb', ...
    'VariableNames', {'NumberOfUsers', 'SIR_dB'});
disp(results);

% Plot CDMA SIR
figure;
plot(K, sirDb, 'o-', 'LineWidth', 1.5);
hold on;
yline(targetSIRdB, '--r', 'Target SIR');

xlabel('Number of Simultaneous Users');
ylabel('Estimated SIR (dB)');
title('CDMA SIR versus Number of Users');
grid on;
hold off;
