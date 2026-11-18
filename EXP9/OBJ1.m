
clc;
clear;
close all;

%% Input Parameters
rng(7);                         % Repeatable random results

K = 4;                          % Number of users
NRB = 24;                       % Number of resource blocks
BRB = 180e3;                    % Bandwidth per RB (Hz)
Tslot = 1e-3;                   % Scheduling interval (seconds)
etaMax = 6;                     % Maximum spectral efficiency (bit/s/Hz)

avgSNRdB = [5 10 15 8];         % Average user SNR (dB)
trafficMbps = [8 12 5 10];      % Offered traffic (Mbit/s)

% Bits requested during one scheduling interval
demandBits = trafficMbps * 1e6 * Tslot;

%% Generate Channel Quality
snrVariation = 4 * randn(K, NRB);
snrDB = avgSNRdB(:) + snrVariation;
snrLinear = 10.^(snrDB / 10);

% Calculate spectral efficiency
spectralEfficiency = min(log2(1 + snrLinear), etaMax);

% Achievable bits per RB
rateBps = BRB * spectralEfficiency;
bitsPerRB = rateBps * Tslot;

strategyNames = {'Round Robin', 'Maximum CQI', 'Traffic Aware'};
allocations = zeros(K, NRB, 3);

%% Strategy 1: Round Robin Allocation
for n = 1:NRB
    user = mod(n - 1, K) + 1;
    allocations(user, n, 1) = 1;
end

%% Strategy 2: Maximum CQI Allocation
for n = 1:NRB
    [~, user] = max(snrDB(:, n));
    allocations(user, n, 2) = 1;
end

%% Strategy 3: Traffic-Aware Allocation
servedBits = zeros(K, 1);

for n = 1:NRB
    remainingBits = max(demandBits(:) - servedBits, 0);

    if all(remainingBits <= 0)
        break;
    end

    normalizedDemand = remainingBits ./ max(demandBits(:), eps);
    metric = bitsPerRB(:, n) .* normalizedDemand;

    metric(remainingBits <= 0) = -inf;

    [~, user] = max(metric);
    allocations(user, n, 3) = 1;

    deliveredBits = min(bitsPerRB(user, n), remainingBits(user));
    servedBits(user) = servedBits(user) + deliveredBits;
end

%% Performance Calculations
userThroughputMbps = zeros(K, 3);
totalThroughputMbps = zeros(1, 3);
jainFairness = zeros(1, 3);
utilization = zeros(1, 3);
unservedTrafficMbps = zeros(K, 3);
rbPerUser = zeros(K, 3);

for s = 1:3

    allocation = allocations(:, :, s);
    deliveredBits = sum(allocation .* bitsPerRB, 2);

    % Useful throughput
    usefulBits = min(deliveredBits, demandBits(:));
    userThroughputMbps(:, s) = usefulBits / Tslot / 1e6;

    totalThroughputMbps(s) = sum(userThroughputMbps(:, s));

    throughput = userThroughputMbps(:, s);

    % Jain's Fairness Index
    jainFairness(s) = sum(throughput)^2 / ...
        (K * sum(throughput.^2) + eps);

    % RB utilization
    allocatedRBs = sum(allocation(:));
    utilization(s) = allocatedRBs / NRB * 100;

    % Unserved traffic
    unservedTrafficMbps(:, s) = ...
        max(trafficMbps(:) - throughput, 0);

    rbPerUser(:, s) = sum(allocation, 2);

end

%% Display Results
fprintf('\nOFDMA RESOURCE-BLOCK ALLOCATION RESULTS\n');
fprintf('=======================================\n');

for s = 1:3

    fprintf('\n%s\n', strategyNames{s});
    fprintf('User\tRBs\tThroughput (Mbit/s)\tUnserved (Mbit/s)\n');

    for k = 1:K
        fprintf('%d\t%d\t%8.3f\t\t%8.3f\n', ...
            k, rbPerUser(k, s), ...
            userThroughputMbps(k, s), ...
            unservedTrafficMbps(k, s));
    end

    fprintf('Total throughput: %.3f Mbit/s\n', ...
        totalThroughputMbps(s));

    fprintf('Jain fairness: %.4f\n', jainFairness(s));

    fprintf('RB utilization: %.2f %%\n', utilization(s));

end

%% Allocation Maps Plotting
figure('Name', 'OFDMA Resource-Block Allocation');

for s = 1:3

    subplot(3, 1, s);

    [userIndex, rbIndex] = find(allocations(:, :, s));

    stem(rbIndex, userIndex, 'filled', 'LineWidth', 1.1);

    grid on;
    xlim([1 NRB]);
    ylim([0.5 K + 0.5]);
    yticks(1:K);

    xlabel('Resource-block index');
    ylabel('Allocated user');
    title(strategyNames{s});

end

%% Throughput Comparison Plotting
figure('Name', 'User Throughput Comparison');

bar(userThroughputMbps);

xlabel('User');
ylabel('Throughput (Mbit/s)');
title('User Throughput Under Different Allocation Strategies');

legend(strategyNames, 'Location', 'best');
