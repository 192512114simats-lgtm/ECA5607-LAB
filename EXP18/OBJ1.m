
clc;
clear;
close all;

%% 1. GENERATE 5G TRAFFIC DATASET
N = 100;
t = 1:N;

rng(1);
traffic = 50 + 10*sin(2*pi*t/25) + 5*randn(1,N);
traffic(traffic < 1) = 1;

%% 2. TRAINING AND TESTING DATA
trainN = round(0.70*N);

trainTime = t(1:trainN);
trainTraffic = traffic(1:trainN);

testTime = t(trainN+1:end);
testTraffic = traffic(trainN+1:end);

%% 3. BASELINE PREDICTION - PREVIOUS SAMPLE
baselinePred = [trainTraffic(end), testTraffic(1:end-1)];

%% 4. AI-BASED PREDICTION - LINEAR REGRESSION
X = trainTraffic(1:end-1)';
Y = trainTraffic(2:end)';

model = fitlm(X,Y);

aiPred = predict(model, baselinePred');
aiPred = aiPred';

%% 5. ERROR CALCULATION
MAE_baseline = mean(abs(testTraffic - baselinePred));

RMSE_baseline = sqrt(mean((testTraffic - baselinePred).^2));

MAPE_baseline = mean(abs((testTraffic - baselinePred) ...
    ./ testTraffic))*100;

MAE_AI = mean(abs(testTraffic - aiPred));

RMSE_AI = sqrt(mean((testTraffic - aiPred).^2));

MAPE_AI = mean(abs((testTraffic - aiPred) ...
    ./ testTraffic))*100;

%% 6. DISPLAY RESULTS
fprintf('AI-Based 5G Traffic Prediction\n');
fprintf('------------------------------\n');

fprintf('Baseline MAE = %.3f Mbps\n', MAE_baseline);
fprintf('Baseline RMSE = %.3f Mbps\n', RMSE_baseline);
fprintf('Baseline MAPE = %.3f %%\n', MAPE_baseline);

fprintf('\nAI Model Results:\n');

fprintf('AI Model MAE = %.3f Mbps\n', MAE_AI);
fprintf('AI Model RMSE = %.3f Mbps\n', RMSE_AI);
fprintf('AI Model MAPE = %.3f %%\n', MAPE_AI);

%% 7. PLOT ACTUAL AND PREDICTED TRAFFIC
figure;
plot(testTime, testTraffic, '-o', 'LineWidth', 1.5);
hold on;

plot(testTime, baselinePred, '--s', 'LineWidth', 1.5);
plot(testTime, aiPred, '-^', 'LineWidth', 1.5);

grid on;
xlabel('Time Sample');
ylabel('Traffic Load (Mbps)');
title('5G Network Traffic Prediction');

legend('Actual Traffic', 'Baseline Prediction', ...
    'AI Prediction');

%% 8. ERROR COMPARISON
figure;
bar([MAE_baseline MAE_AI; RMSE_baseline RMSE_AI]);

grid on;
xlabel('Performance Metric');
ylabel('Error');
title('Baseline and AI Prediction Error Comparison');

xticklabels({'MAE', 'RMSE'});
legend('Baseline', 'AI Model');
