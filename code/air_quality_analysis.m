%% Air Quality Analysis: Parma (Italy) vs Kyiv (Ukraine, Oct 2023)
%  Raspberry Pi + SDS011 sensor | WHO limits: PM2.5=15, PM10=45 ug/m3
%  Analysis: Time series -> K-Means clustering -> Regression (Parma only)

clear; clc; close all;

% Load the two datasets
parma = load('parma_collected.mat');   % our field collection in Parma
kyiv  = load('kyiv_real.mat');         % SaveEcoBot open data, Kyiv Oct 2023

pm25_p = parma.pm25(:);   % Parma PM2.5 readings (3600 samples)
pm10_p = parma.pm10(:);   % Parma PM10  readings
pm25_k = kyiv.pm25(:);    % Kyiv  PM2.5 readings
pm10_k = kyiv.pm10(:);    % Kyiv  PM10  readings

N     = length(pm25_p);   % number of samples = 3600
t     = (1:N)';           % sample index used as x-axis in time series
WHO25 = 15;               % WHO safe limit for PM2.5
WHO10 = 45;               % WHO safe limit for PM10

% Time series: see how pollution changes over 3600 readings
[pk25k, pkidx] = max(pm25_k);  % find the single highest PM2.5 reading in Kyiv

figure
subplot(2,2,1)                  % top-left panel: Parma PM2.5
plot(t, pm25_p, 'Color',[0.1 0.6 0.1], 'LineWidth',0.7)
hold on
yline(WHO25, 'r--', 'LineWidth',1.8)
xlabel('Sample index'); ylabel('ug/m3')
title('PM2.5 - Parma', 'FontWeight','bold')
ylim([0 35]); grid on; box on

subplot(2,2,2)                  % top-right: Kyiv PM2.5 with event label
plot(t, pm25_k, 'Color',[0.8 0.1 0.1], 'LineWidth',0.7)
hold on
yline(WHO25, 'b--', 'LineWidth',1.8)
text(pkidx-200, pk25k-80, ...
    sprintf('Event peak\n%.0f ug/m3\n(Oct 27)', pk25k), ...
    'FontSize',8, 'BackgroundColor','yellow', 'EdgeColor','k')
xlabel('Sample index'); ylabel('ug/m3')
title('PM2.5 - Kyiv', 'FontWeight','bold'); grid on; box on

subplot(2,2,3)                  % bottom-left: Parma PM10
plot(t, pm10_p, 'Color',[0.1 0.3 0.8], 'LineWidth',0.7)
hold on
yline(WHO10, 'r--', 'LineWidth',1.8)
xlabel('Sample index'); ylabel('ug/m3')
title('PM10 - Parma', 'FontWeight','bold'); grid on; box on

subplot(2,2,4)                  % bottom-right: Kyiv PM10
plot(t, pm10_k, 'Color',[0.6 0.0 0.6], 'LineWidth',0.7)
hold on
yline(WHO10, 'b--', 'LineWidth',1.8)
xlabel('Sample index'); ylabel('ug/m3')
title('PM10 - Kyiv', 'FontWeight','bold'); grid on; box on

sgtitle('Air Quality Time Series: Parma vs Kyiv', 'FontSize',14, 'FontWeight','bold')

% K-Means Clustering
% Stack both cities: 7200 rows x 2 columns [PM2.5, PM10]
% The algorithm sees only numbers - no city names, no dates, no context
X = [pm25_p, pm10_p;
     pm25_k, pm10_k];

% Normalise: zscore makes both variables have mean=0 and std=1
% Without this PM10 (max ~1600) would dominate PM2.5 (max ~26)
X = zscore(X);

% Elbow method: try K=1 to 6 and measure within-cluster spread
% Best K is where the curve bends and stops improving much
inertia = zeros(1,6);
for k = 1:6
    [~, ~, sumdj] = kmeans(X, k, 'Replicates',20);
    inertia(k)    = sum(sumdj);
end

figure
plot(1:6, inertia, 'bo-', 'LineWidth',2, 'MarkerFaceColor','b', 'MarkerSize',7)
xline(3, 'r--', 'LineWidth',1.5, 'Label','K = 3 (chosen)')
xlabel('Number of clusters K')
ylabel('Total inertia')
title('Elbow Method - Choosing K', 'FontWeight','bold')
grid on

% Final clustering with K=3 (Clean / Moderate / Extreme)
rng('default')                  % fix random seed -> same result every run
[idx, cent, sumdj] = kmeans(X, 3, 'Replicates',30);
sumd = sum(sumdj);

% Verify centroids match group means
Centroids = grpstats(X, idx);
assert(max(abs(cent - Centroids),[],'all') < 1e-08, 'Programming error')

% Cluster plot: full view + zoomed view side by side
figure

% Left panel: full view showing all 7200 points including the extreme cluster
subplot(1,2,1)
gscatter(X(:,1), X(:,2), idx, 'brk', 'xos', 8)
hold on
gscatter(Centroids(:,1), Centroids(:,2), 1:3, 'brk', 'p', 15)
xlabel('PM2.5 (normalised)')
ylabel('PM10 (normalised)')
title('All 7200 points - event cluster visible far right', 'FontWeight','bold')
grid on

% Right panel: zoom into the bottom-left corner where normal readings sit
subplot(1,2,2)
gscatter(X(:,1), X(:,2), idx, 'brk', 'xos', 8)
hold on
gscatter(Centroids(:,1), Centroids(:,2), 1:3, 'brk', 'p', 15)
xlim([-1 4])
ylim([-1 4])
xlabel('PM2.5 (normalised)')
ylabel('PM10 (normalised)')
title('Zoomed - Clean Air vs Moderate clusters', 'FontWeight','bold')
grid on

sgtitle('K=3 Clustering: Full View and Zoomed View', 'FontSize',13, 'FontWeight','bold')

% Regression: Parma only - PM10 ~ PM2.5
% In normal urban life, does PM2.5 predict PM10?
% Parma only - Kyiv's single extreme event would distort the whole model
mdl = fitlm(parma.pm25(:), parma.pm10(:));
disp(mdl)

CI = coefCI(mdl, 0.05);
fprintf('Slope 95%% CI: [%.4f, %.4f]\n', CI(2,1), CI(2,2))

% Scatter with fitted line and confidence band
figure
scatter(parma.pm25(:), parma.pm10(:), 20, 'filled', 'MarkerFaceAlpha',0.3)
hold on
x_fit         = linspace(min(parma.pm25(:)), max(parma.pm25(:)), 200)';
[yfit, cifit] = predict(mdl, x_fit, 'Prediction','curve');
plot(x_fit, yfit, 'k-', 'LineWidth',2)
plot(x_fit, cifit(:,1), 'k--', x_fit, cifit(:,2), 'k--')
xlabel('PM2.5 (ug/m3)'); ylabel('PM10 (ug/m3)')
title(sprintf('Parma: PM10 ~ PM2.5  |  R2=%.4f', mdl.Rsquared.Ordinary), ...
    'FontWeight','bold')
legend('Data', 'Fitted line', '95% CI', 'Location','best')
grid on
