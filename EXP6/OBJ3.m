
clc;
clear;
close all;

N = 8;                  % Antenna elements
theta = -90:1:90;       % Observation angle
steer = [-60 -30 0 30 60]; % Steering directions

gain = zeros(size(steer));

for k = 1:length(steer)

    % Simplified normalized array response
    % at the intended direction
    gain(k) = 10*log10(N) - 0.01*abs(steer(k));

end

% Plot Beamforming Gain
figure;

plot(steer, gain, 'o-', 'LineWidth', 2);

grid on;
xlabel('Steering Angle (Degrees)');
ylabel('Beamforming Gain (dB)');
title('Beamforming Gain for Different Steering Directions');
