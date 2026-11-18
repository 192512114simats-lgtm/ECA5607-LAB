
% Experiment 4: Hardware Measurement of Wireless Coverage
% and Channel Interference Using Raspberry Pi and ESP32

clc;
clear;
close all;

%% 1. Define Experimental Parameters

location = (1:5)';
distance = [2; 5; 10; 15; 20];       % Distance in meters
obstruction = ["Open"; "Open"; "Wall"; "Wall"; "Wall"];

% Illustrative RSSI measurements (dBm), 10 samples per location
rssi = [
    -40 -42 -41 -43 -40 -41 -42 -44 -41 -42;
    -48 -50 -49 -51 -48 -52 -49 -50 -51 -49;
    -58 -60 -59 -62 -61 -60 -58 -63 -61 -59;
    -65 -67 -66 -68 -65 -69 -67 -66 -68 -67;
    -72 -74 -73 -75 -71 -76 -74 -73 -75 -72
];

%% 2. Calculate RSSI Statistics

medianRSSI = median(rssi, 2);
minRSSI = min(rssi, [], 2);
maxRSSI = max(rssi, [], 2);

rssiRange = strings(length(location), 1);

for i = 1:length(location)
    rssiRange(i) = sprintf('%d to %d', ...
        minRSSI(i), maxRSSI(i));
end

%% 3. Define Channel Activity and Ping Results

% Illustrative visible access point counts on channels 1, 6 and 11
channel1 = [2; 3; 3; 4; 4];
channel6 = [3; 4; 5; 5; 6];
channel11 = [1; 2; 2; 3; 3];

% Illustrative local gateway ping results
pingLoss = [0; 0; 5; 10; 15];       % Percentage
avgLatency = [2; 3; 5; 8; 12];      % Milliseconds

%% 4. Display Results Table

resultsTable = table( ...
    location, distance, obstruction, ...
    medianRSSI, rssiRange, ...
    channel1, channel6, channel11, ...
    pingLoss, avgLatency, ...
    'VariableNames', { ...
    'Location', 'Distance_m', 'Obstruction', ...
    'MedianRSSI_dBm', 'RSSI_MinMax_dBm', ...
    'Channel1_APs', 'Channel6_APs', 'Channel11_APs', ...
    'PingLoss_percent', 'AvgLatency_ms'});

disp('Wi-Fi Coverage and Channel Interference Results');
disp(resultsTable);

%% 5. Plot RSSI versus Distance

figure;

plot(distance, medianRSSI, 'o-', ...
    'LineWidth', 1.5, 'MarkerSize', 7);

grid on;
xlabel('Distance (m)');
ylabel('Median RSSI (dBm)');
title('Wi-Fi Signal Strength versus Distance');

%% 6. Plot RSSI Variation at Each Location

figure;

errorbar(distance, medianRSSI, ...
    medianRSSI - minRSSI, ...
    maxRSSI - medianRSSI, 'o-', ...
    'LineWidth', 1.5, 'MarkerSize', 7);

grid on;
xlabel('Distance (m)');
ylabel('RSSI (dBm)');
title('RSSI Variation across Measurement Locations');
legend('Median RSSI with Min-Max Range', ...
    'Location', 'best');

%% 7. Compare Visible Access Points by Channel

figure;

bar(distance, [channel1 channel6 channel11], 'grouped');

grid on;
xlabel('Distance (m)');
ylabel('Number of Visible Access Points');
title('Observed Wi-Fi Access Points by Channel');
legend('Channel 1', 'Channel 6', 'Channel 11', ...
    'Location', 'northwest');

%% 8. Plot Packet Loss and Average Latency

figure;

subplot(2, 1, 1);

plot(distance, pingLoss, 'o-', 'LineWidth', 1.5);

grid on;
xlabel('Distance (m)');
ylabel('Packet Loss (%)');
title('Local Gateway Packet Loss');

subplot(2, 1, 2);

plot(distance, avgLatency, 's-', 'LineWidth', 1.5);

grid on;
xlabel('Distance (m)');
ylabel('Average Latency (ms)');
title('Local Gateway Average Latency');

%% 9. Display Summary

fprintf('\nEXPERIMENT SUMMARY\n');

fprintf('Nearest location RSSI: %.1f dBm\n', ...
    medianRSSI(1));

fprintf('Farthest location RSSI: %.1f dBm\n', ...
    medianRSSI(end));

fprintf('RSSI change: %.1f dB\n', ...
    medianRSSI(end) - medianRSSI(1));

fprintf('Farthest location packet loss: %.1f%%\n', ...
    pingLoss(end));

disp('Experiment completed successfully.');
