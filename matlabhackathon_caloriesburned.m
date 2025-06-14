load MobileSensorData/sensorlog_20250614_133008.mat;

Fs = 10;
t = 0:1/Fs:600; 
accel = randn(length(t), 3) * 2; 
gyro = randn(length(t), 3) * 10; 
orientation = randn(length(t), 4); 
position = cumsum(randn(length(t), 3)); 

weight_kg = input('Enter your weight: ');

sma = sum(abs(accel), 2);

windowSize = 5;
sma_smooth = movmean(sma, windowSize);


met = sma_smooth * 0.5;

time_hours = t / 3600;
calories_per_sec = met .* weight_kg / 3600; 
calories_cumulative = cumsum(calories_per_sec) / Fs; % Total kcal
figure;

% Subplot 1: Acceleration and SMA
subplot(3,1,1);
plot(t, accel(:,1), 'r', t, accel(:,2), 'g', t, accel(:,3), 'b');
hold on;
plot(t, sma_smooth, 'k', 'LineWidth', 2);
legend('Accel-X', 'Accel-Y', 'Accel-Z', 'SMA (Smoothed)');
xlabel('Time (s)');
ylabel('Acceleration (m/s²)');
title('Acceleration and Signal Magnitude Area');

% Subplot 2: Angular Velocity
subplot(3,1,2);
plot(t, gyro(:,1), 'r', t, gyro(:,2), 'g', t, gyro(:,3), 'b');
legend('Gyro-X', 'Gyro-Y', 'Gyro-Z');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
title('Angular Velocity');

% Subplot 3: Calories Burned
subplot(3,1,3);
plot(t, calories_cumulative, 'm', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Calories Burned (kcal)');
title('Cumulative Calories Burned');
grid on;