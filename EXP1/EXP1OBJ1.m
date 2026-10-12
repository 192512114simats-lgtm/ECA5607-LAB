
% Comparison of FDMA, TDMA and CDMA

clear;
clc;
close all;

% System parameters
totalBandwidthHz = 1e6;
fdmaChannelHz = 200e3;
tdmaSlots = 8;
processingGain = 64;
targetSIRdB = 7;

% Calculate supported users
fdmaUsers = floor(totalBandwidthHz / fdmaChannelHz);
tdmaUsers = tdmaSlots;

targetSIR = 10^(targetSIRdB / 10);
cdmaUsers = floor(1 + processingGain / targetSIR);

% Display results
fprintf('Maximum Supported Users\n');
fprintf('FDMA: %d users\n', fdmaUsers);
fprintf('TDMA: %d users\n', tdmaUsers);
fprintf('CDMA: %d users\n', cdmaUsers);

% Comparison table
method = ["FDMA"; "TDMA"; "CDMA"];
supportedUsers = [fdmaUsers; tdmaUsers; cdmaUsers];

results = table(method, supportedUsers);
disp(results);

% Plot user capacity
figure;
bar(categorical(method), supportedUsers);
xlabel('Multiple Access Techniques');
ylabel('Estimated Number of Users');
title('FDMA, TDMA and CDMA Capacity Comparison');
grid on;
