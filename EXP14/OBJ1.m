
clc;
clear;
close all;

%% EDGE AND CLOUD PROCESSING SIMULATION

% IoT Sensor Parameters
N = 10;
sensor_rate_kbps = 10;
simulation_time = 60;

% Network Parameters
bandwidth_bps = 1e6;
network_delay_s = 0.050;

% Processing Parameters
edge_processing_s = 0.020;
cloud_processing_s = 0.010;

% Data Reduction Ratio
reduction_ratio = 0.90;

% Power Parameters
tx_power_W = 0.5;
edge_power_W = 1.0;
cloud_power_W = 5.0;

%% 1. Calculate Data Rates
raw_rate_bps = N * sensor_rate_kbps * 1000;

edge_rate_bps = raw_rate_bps * (1 - reduction_ratio);
cloud_rate_bps = raw_rate_bps;

%% 2. One-Second Batch Data Volume
batch_duration_s = 1;

edge_data_bits = edge_rate_bps * batch_duration_s;
cloud_data_bits = cloud_rate_bps * batch_duration_s;

%% 3. Transmission Times
edge_tx_time_s = edge_data_bits / bandwidth_bps;
cloud_tx_time_s = cloud_data_bits / bandwidth_bps;

%% 4. Total Response Times
edge_latency_s = edge_processing_s;

cloud_latency_s = network_delay_s + ...
    cloud_tx_time_s + cloud_processing_s;

latency_ms = [edge_latency_s, cloud_latency_s] * 1000;

%% 5. Bandwidth Utilization
edge_utilization = edge_rate_bps / bandwidth_bps * 100;
cloud_utilization = cloud_rate_bps / bandwidth_bps * 100;

%% 6. Energy Consumption
edge_tx_energy_J = tx_power_W * edge_tx_time_s;
cloud_tx_energy_J = tx_power_W * cloud_tx_time_s;

edge_processing_energy_J = edge_power_W * edge_processing_s;
cloud_processing_energy_J = cloud_power_W * cloud_processing_s;

edge_total_energy_J = ...
    edge_tx_energy_J + edge_processing_energy_J;

cloud_total_energy_J = ...
    cloud_tx_energy_J + cloud_processing_energy_J;

%% 7. Display Results Table
Architecture = {'Edge Processing'; 'Cloud Processing'};

RawDataRate_kbps = [raw_rate_bps; raw_rate_bps] / 1000;

RemoteDataRate_kbps = ...
    [edge_rate_bps; cloud_rate_bps] / 1000;

ProcessingTime_ms = ...
    [edge_processing_s; cloud_processing_s] * 1000;

NetworkDelay_ms = [0; network_delay_s * 1000];

TransmissionTime_ms = ...
    [edge_tx_time_s; cloud_tx_time_s] * 1000;

ResponseTime_ms = latency_ms';

BandwidthUtilization_percent = ...
    [edge_utilization; cloud_utilization];

EnergyPerBatch_J = ...
    [edge_total_energy_J; cloud_total_energy_J];

Results = table(Architecture, RawDataRate_kbps, ...
    RemoteDataRate_kbps, ProcessingTime_ms, ...
    NetworkDelay_ms, TransmissionTime_ms, ...
    ResponseTime_ms, BandwidthUtilization_percent, ...
    EnergyPerBatch_J);

disp('==============================================');
disp('       EDGE AND CLOUD PROCESSING RESULTS');
disp('==============================================');

disp(Results);

%% Plot 1: Response Time Comparison
figure('Name', 'Plot 1 - Response Time', 'Color', 'w');

plot(1:2, latency_ms, 'o-', ...
    'LineWidth', 2, 'MarkerSize', 9);

set(gca, 'XTick', 1:2, ...
    'XTickLabel', {'Edge', 'Cloud'});

xlim([0.5 2.5]);

ylabel('Response Time (ms)');
xlabel('Processing Architecture');
title('Plot 1: Edge vs Cloud Response Time');

grid on;

for k = 1:2
    text(k, latency_ms(k), ...
        sprintf(' %.1f ms', latency_ms(k)), ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center');
end

%% Plot 2: Remote Data Rate
figure('Name', 'Plot 2 - Data Rate', 'Color', 'w');

remote_rate_kbps = [edge_rate_bps, cloud_rate_bps] / 1000;

plot(1:2, remote_rate_kbps, 's-', ...
    'LineWidth', 2, 'MarkerSize', 9);

set(gca, 'XTick', 1:2, ...
    'XTickLabel', {'Edge', 'Cloud'});

xlim([0.5 2.5]);

ylabel('Remote Data Rate (kbps)');
xlabel('Processing Architecture');
title('Plot 2: Data Sent to Remote Server');

grid on;

for k = 1:2
    text(k, remote_rate_kbps(k), ...
        sprintf(' %.1f kbps', remote_rate_kbps(k)), ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center');
end

%% Plot 3: Network Bandwidth Utilization
figure('Name', 'Plot 3 - Bandwidth', 'Color', 'w');

utilization = [edge_utilization, cloud_utilization];

plot(1:2, utilization, 'd-', ...
    'LineWidth', 2, 'MarkerSize', 9);

set(gca, 'XTick', 1:2, ...
    'XTickLabel', {'Edge', 'Cloud'});

xlim([0.5 2.5]);

ylabel('Bandwidth Utilization (%)');
xlabel('Processing Architecture');
title('Plot 3: Network Bandwidth Utilization');

grid on;

for k = 1:2
    text(k, utilization(k), ...
        sprintf(' %.1f%%', utilization(k)), ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center');
end

%% Plot 4: Energy Consumption
figure('Name', 'Plot 4 - Energy', 'Color', 'w');

energy = [edge_total_energy_J, cloud_total_energy_J];

plot(1:2, energy, '^-', ...
    'LineWidth', 2, 'MarkerSize', 9);

set(gca, 'XTick', 1:2, ...
    'XTickLabel', {'Edge', 'Cloud'});

xlim([0.5 2.5]);

ylabel('Energy (J per one-second batch)');
xlabel('Processing Architecture');
title('Plot 4: Modeled Energy Consumption');

grid on;

for k = 1:2
    text(k, energy(k), ...
        sprintf(' %.3f J', energy(k)), ...
        'VerticalAlignment', 'bottom', ...
        'HorizontalAlignment', 'center');
end

%% Final Summary
fprintf('\nEdge response time: %.2f ms\n', ...
    edge_latency_s * 1000);

fprintf('Cloud response time: %.2f ms\n', ...
    cloud_latency_s * 1000);

fprintf('Edge remote data rate: %.2f kbps\n', ...
    edge_rate_bps / 1000);

fprintf('Cloud remote data rate: %.2f kbps\n', ...
    cloud_rate_bps / 1000);

fprintf('Edge energy per batch: %.4f J\n', ...
    edge_total_energy_J);

fprintf('Cloud energy per batch: %.4f J\n', ...
    cloud_total_energy_J);

fprintf('\nSimulation completed successfully.\n');
