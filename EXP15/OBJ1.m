
clc;
clear;
close all;

%% 1. INPUT PARAMETERS
N = 5;
moisture_threshold = 30;
sampling_interval = 10;
simulation_time = 60;
packet_size_bytes = 100;
data_rate_bps = 50000;
pump_power_W = 20;

%% 2. SIMULATION TIME
time = 0:sampling_interval:simulation_time-sampling_interval;

%% 3. SENSOR READINGS
soil_moisture = [25 27 29 31 32 28];
temperature = [32 32.2 32.5 32.1 31.8 31.5];
humidity = [65 64 63 64 66 67];

%% 4. AUTOMATIC IRRIGATION CONTROL
pump_status = soil_moisture < moisture_threshold;
pump_on_time_s = sum(pump_status) * sampling_interval;

%% 5. COMMUNICATION CALCULATIONS
samples_per_sensor = length(time);
total_packets = N * samples_per_sensor;
total_data_bytes = total_packets * packet_size_bytes;
total_data_bits = total_data_bytes * 8;
transmission_time_s = total_data_bits / data_rate_bps;

%% 6. PUMP ENERGY CALCULATION
pump_energy_J = pump_power_W * pump_on_time_s;
pump_energy_Wh = pump_energy_J / 3600;

%% OUTPUT 1: NUMERICAL RESULTS
fprintf('\nSMART AGRICULTURE SIMULATION RESULTS\n');
fprintf('------------------------------------\n');
fprintf('Number of sensor nodes: %d\n', N);
fprintf('Samples per sensor: %d\n', samples_per_sensor);
fprintf('Total packets transmitted: %d\n', total_packets);
fprintf('Total data transmitted: %d bytes\n', total_data_bytes);
fprintf('Total data transmitted: %d bits\n', total_data_bits);
fprintf('Ideal transmission time: %.3f seconds\n', transmission_time_s);
fprintf('Pump ON duration: %.1f seconds\n', pump_on_time_s);
fprintf('Pump energy: %.2f J\n', pump_energy_J);
fprintf('Pump energy: %.4f Wh\n', pump_energy_Wh);

%% OUTPUT 2: SENSOR READINGS TABLE
fprintf('\nSENSOR READINGS TABLE\n');

results = table(time', soil_moisture', temperature', ...
    humidity', pump_status', ...
    'VariableNames', {'Time_s', 'SoilMoisture_pct', ...
    'Temperature_C', 'Humidity_pct', 'Pump_ON'});

disp(results);

%% OUTPUT 3: SOIL MOISTURE GRAPH
figure;
plot(time, soil_moisture, '-o');
hold on;
plot(time, moisture_threshold * ones(size(time)), '--');
xlabel('Time (seconds)');
ylabel('Soil Moisture (%)');
title('Soil Moisture Monitoring');
grid on;
hold off;

%% OUTPUT 4: TEMPERATURE GRAPH
figure;
plot(time, temperature, '-o');
xlabel('Time (seconds)');
ylabel('Temperature (C)');
title('Temperature Monitoring');
grid on;

%% OUTPUT 5: HUMIDITY GRAPH
figure;
plot(time, humidity, '-o');
xlabel('Time (seconds)');
ylabel('Relative Humidity (%)');
title('Humidity Monitoring');
grid on;

%% OUTPUT 6: PUMP STATUS GRAPH
figure;
stairs(time, double(pump_status), '-o');
xlabel('Time (seconds)');
ylabel('Pump Status (0 = OFF, 1 = ON)');
title('Automatic Irrigation Control');
ylim([-0.2 1.2]);
yticks([0 1]);
grid on;

%% FINAL OUTPUT
fprintf('\nSimulation completed successfully.\n');
fprintf('Six output sections generated.\n');
