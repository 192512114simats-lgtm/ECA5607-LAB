
% Time-Frequency Resource Allocation Diagrams
% FDMA, TDMA and CDMA

clear;
clc;
close all;

figure;
tiledlayout(1,3);

colors = lines(4);

% FDMA: Different frequency channels
nexttile;
hold on;

for u = 1:4
    rectangle('Position', [0, u-1, 1, 0.8], ...
        'FaceColor', colors(u,:), 'EdgeColor', 'k');

    text(0.5, u-0.6, sprintf('User %d', u), ...
        'HorizontalAlignment', 'center');
end

xlim([0 1]);
ylim([0 4]);
xlabel('Time');
ylabel('Frequency channel');
title('FDMA');
set(gca, 'YTick', []);
hold off;

% TDMA: Different time slots
nexttile;
hold on;

for u = 1:4
    rectangle('Position', [u-1, 0, 0.8, 1], ...
        'FaceColor', colors(u,:), 'EdgeColor', 'k');

    text(u-0.6, 0.5, sprintf('User %d', u), ...
        'HorizontalAlignment', 'center');
end

xlim([0 4]);
ylim([0 1]);
xlabel('Time slot');
ylabel('Frequency channel');
title('TDMA');
set(gca, 'YTick', []);
hold off;

% CDMA: Same frequency band and time, different codes
nexttile;
hold on;

for u = 1:4
    rectangle('Position', [0, 0, 1, 1], ...
        'FaceColor', colors(u,:), ...
        'FaceAlpha', 0.22, ...
        'EdgeColor', colors(u,:), ...
        'LineWidth', 1.5);
end

text(0.5, 0.62, 'Users 1-4 share', ...
    'HorizontalAlignment', 'center');

text(0.5, 0.40, 'band; different codes', ...
    'HorizontalAlignment', 'center');

xlim([0 1]);
ylim([0 1]);
xlabel('Time');
ylabel('Frequency band');
title('CDMA');
set(gca, 'YTick', []);
hold off;

% Overall title
sgtitle('Conceptual Time-Frequency Resource Allocation');
