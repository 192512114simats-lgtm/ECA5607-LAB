
% Comparison of FDMA, TDMA and CDMA
% Simplified illustrative model

clear;
clc;
close all;

% Illustrative system parameters
totalBandwidthHz = 1e6;      % Total bandwidth: 1 MHz
fdmaChannelHz = 200e3;       % FDMA channel width: 200 kHz
tdmaSlots = 8;               % Number of TDMA slots per frame
processingGain = 64;         % CDMA processing gain
targetSIRdB = 7;              % Minimum acceptable CDMA SIR

% Capacity estimates
fdmaUsers = floor(totalBandwidthHz / fdmaChannelHz);
tdmaUsers = tdmaSlots;

targetSIR = 10^(targetSIRdB / 10);
cdmaUsers = floor(1 + processingGain / targetSIR);

% Display maximum supported users
fprintf('Illustrative maximum supported users\n');
fprintf('FDMA: %d users\n', fdmaUsers);
fprintf('TDMA: %d users\n', tdmaUsers);
fprintf('CDMA: %d users at a target SIR of %.1f dB\n\n', ...
    cdmaUsers, targetSIRdB);

% CDMA SIR as the number of simultaneous users increases
K = 2:30;
sirLinear = processingGain ./ (K - 1);
sirDb = 10 * log10(sirLinear);

% Display comparison table
method = ["FDMA"; "TDMA"; "CDMA"];
supportedUsers = [fdmaUsers; tdmaUsers; cdmaUsers];

results = table(method, supportedUsers);
disp(results);

% Plot estimated user capacity
figure;
bar(categorical(method), supportedUsers);
ylabel('Illustrative maximum supported simultaneous users');
title('FDMA, TDMA and CDMA: Capacity Estimate');
grid on;

% Plot estimated CDMA SIR
figure;
plot(K, sirDb, 'o-', 'LineWidth', 1.5);
hold on;
yline(targetSIRdB, '--r', 'Target SIR');
xlabel('Number of simultaneous CDMA users (K)');
ylabel('Estimated SIR (dB)');
title('Estimated CDMA SIR versus Number of Users');
grid on;
hold off;
