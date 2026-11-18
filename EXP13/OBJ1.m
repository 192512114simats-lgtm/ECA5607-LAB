
clc;
clear;
close all;

%% NB-IoT vs LTE-M Comparative Analysis

% Common Sensor Parameters
payload_bytes = 200;
sample_interval = 60;
simulation_time = 3600;

% Technology Parameters
tech = {'NB-IoT', 'LTE-M'};
data_rate_bps = [20000, 300000];
success_prob = [0.97, 0.99];
latency_s = [2.0, 0.15];
tx_power_W = [0.20, 0.25];
overhead_s = [0.50, 0.05];

%% Calculations
N_tx = floor(simulation_time / sample_interval);
payload_bits = payload_bytes * 8;

expected_rx = N_tx .* success_prob;
PDR_percent = success_prob .* 100;

throughput_bps = ...
    expected_rx .* payload_bits / simulation_time;

payload_time_s = payload_bits ./ data_rate_bps;

energy_packet_J = tx_power_W .* ...
    (payload_time_s + overhead_s);

energy_bit_J = energy_packet_J ./ ...
    (payload_bits .* success_prob);

%% Display Results Table
Technology = tech';
GeneratedPackets = [N_tx; N_tx];
ExpectedDelivered = expected_rx';
PDR_percent = PDR_percent';
Throughput_bps = throughput_bps';
Latency_s = latency_s';
EnergyPerPacket_J = energy_packet_J';
EnergyPerDeliveredBit_J = energy_bit_J';

Results = table(Technology, GeneratedPackets, ...
    ExpectedDelivered, PDR_percent, Throughput_bps, ...
    Latency_s, EnergyPerPacket_J, ...
    EnergyPerDeliveredBit_J);

disp('==============================================');
disp('       COMPARATIVE ANALYSIS RESULTS');
disp('==============================================');

disp(Results);

%% Plot 1: Effective Throughput
figure('Name', 'Plot 1 - Throughput', 'Color', 'w');

plot(1:2, throughput_bps, 'o-', ...
    'LineWidth', 2, 'MarkerSize', 9);

set(gca, 'XTick', 1:2, 'XTickLabel', tech);
xlim([0.5 2.5]);

ylabel('Throughput (bps)');
xlabel('Technology');
title('Plot 1: Effective Throughput');

grid on;

for k = 1:2
    text(k, throughput_bps(k), ...
        sprintf(' %.3f bps', throughput_bps(k)), ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center');
end

%% Plot 2: One-Way Latency
figure('Name', 'Plot 2 - Latency', 'Color', 'w');

plot(1:2, latency_s, 's-', ...
    'LineWidth', 2, 'MarkerSize', 9);

set(gca, 'XTick', 1:2, 'XTickLabel', tech);
xlim([0.5 2.5]);

ylabel('Latency (seconds)');
xlabel('Technology');
title('Plot 2: One-Way Latency');

grid on;

for k = 1:2
    text(k, latency_s(k), ...
        sprintf(' %.2f s', latency_s(k)), ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center');
end

%% Plot 3: Packet Delivery Ratio
figure('Name', 'Plot 3 - PDR', 'Color', 'w');

plot(1:2, PDR_percent, 'd-', ...
    'LineWidth', 2, 'MarkerSize', 9);

set(gca, 'XTick', 1:2, 'XTickLabel', tech);
xlim([0.5 2.5]);
ylim([0 110]);

ylabel('Packet Delivery Ratio (%)');
xlabel('Technology');
title('Plot 3: Packet Delivery Ratio');

grid on;

for k = 1:2
    text(k, PDR_percent(k), ...
        sprintf(' %.1f%%', PDR_percent(k)), ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center');
end

%% Plot 4: Modeled Transmission Energy
figure('Name', 'Plot 4 - Energy', 'Color', 'w');

plot(1:2, energy_packet_J, '^-', ...
    'LineWidth', 2, 'MarkerSize', 9);

set(gca, 'XTick', 1:2, 'XTickLabel', tech);
xlim([0.5 2.5]);

ylabel('Energy (J/packet)');
xlabel('Technology');
title('Plot 4: Modeled Transmission Energy');

grid on;

for k = 1:2
    text(k, energy_packet_J(k), ...
        sprintf(' %.5f J', energy_packet_J(k)), ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center');
end

%% Final Summary
fprintf('\nNB-IoT Throughput: %.3f bps\n', ...
    throughput_bps(1));

fprintf('LTE-M Throughput: %.3f bps\n', ...
    throughput_bps(2));

fprintf('NB-IoT Latency: %.2f seconds\n', ...
    latency_s(1));

fprintf('LTE-M Latency: %.2f seconds\n', ...
    latency_s(2));

fprintf('NB-IoT PDR: %.1f%%\n', PDR_percent(1));

fprintf('LTE-M PDR: %.1f%%\n', PDR_percent(2));

fprintf('NB-IoT Energy: %.5f J/packet\n', ...
    energy_packet_J(1));

fprintf('LTE-M Energy: %.5f J/packet\n', ...
    energy_packet_J(2));

fprintf('\nAll four plots generated successfully.\n');
