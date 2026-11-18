
clc;
clear;
close all;

%% SIMULATION PARAMETERS
N = 1000;               % Number of packets
packetSize = 300 * 8;    % Packet size in bits
Rb = 10e6;              % Data rate = 10 Mbps
c = 3e8;                % Propagation speed
Tp = 1e-3;              % Processing delay
Tq = 1e-3;              % Queuing delay

% Communication distances
distance = [50 100 150 200];

% Packet loss probabilities
Ploss1 = 0.05;          % Scenario 1
Ploss2 = 0.15;          % Scenario 2

%% TRANSMISSION DELAY
Ttx = packetSize / Rb;

%% LATENCY CALCULATION
Tprop = distance / c;
Latency = Ttx + Tprop + Tp + Tq;

%% SCENARIO 1 - RELIABLE CHANNEL
PDR1 = (1 - Ploss1) * 100;

Received1 = round(N * (1 - Ploss1));
Lost1 = N - Received1;

%% SCENARIO 2 - POORER CHANNEL
PDR2 = (1 - Ploss2) * 100;

Received2 = round(N * (1 - Ploss2));
Lost2 = N - Received2;

%% DISPLAY RESULTS
fprintf('V2X Communication Simulation\n');
fprintf('----------------------------\n');
fprintf('Packet Size = %d bits\n', packetSize);
fprintf('Data Rate = %.2f Mbps\n', Rb/1e6);
fprintf('Transmission Delay = %.4f ms\n', Ttx*1000);

fprintf('\nScenario 1:\n');
fprintf('Received Packets = %d\n', Received1);
fprintf('Lost Packets = %d\n', Lost1);
fprintf('PDR = %.2f %%\n', PDR1);

fprintf('\nScenario 2:\n');
fprintf('Received Packets = %d\n', Received2);
fprintf('Lost Packets = %d\n', Lost2);
fprintf('PDR = %.2f %%\n', PDR2);

%% PLOT 1 - LATENCY VERSUS DISTANCE
figure;
plot(distance, Latency*1000, '-o', 'LineWidth', 2);
grid on;
xlabel('Communication Distance (m)');
ylabel('Latency (ms)');
title('V2X Communication Latency vs Distance');

%% PLOT 2 - PDR COMPARISON
figure;
bar([PDR1 PDR2]);
grid on;
xlabel('Scenario');
ylabel('Packet Delivery Ratio (%)');
title('V2X Packet Delivery Ratio Comparison');
xticklabels({'Scenario 1', 'Scenario 2'});

%% PLOT 3 - PDR VERSUS DISTANCE
PDR_distance_1 = PDR1 - 0.02*distance;
PDR_distance_2 = PDR2 - 0.03*distance;

figure;
plot(distance, PDR_distance_1, '-o', 'LineWidth', 2);
hold on;
plot(distance, PDR_distance_2, '-s', 'LineWidth', 2);
grid on;
xlabel('Communication Distance (m)');
ylabel('Packet Delivery Ratio (%)');
title('PDR versus Communication Distance');
legend('Scenario 1', 'Scenario 2');
