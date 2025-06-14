clear;
m = mobiledev;
m.AccelerationSensorEnabled = 1;
m.Logging = 1;

log_duration = 15; %in seconds
pause(15);

m.Logging = 0;

[a, t] = accellog(m); %get data

a_total = sqrt(sum(a.^2, 2));
a_NoG = a_total - mean(a_total);
a_smooth = smooth(a_NoG, 5);


intensity_value = std(a_smooth);


if intensity_value < 0.3
    intensity_label = "🟢 Light";
elseif intensity_value < 0.7
    intensity_label = "🟡 Moderate";
else
    intensity_label = "🔴 Intense";
end

fprintf("Activity Intensity: %s (%.3f)\n", intensity_label, intensity_value);


threshold = mean(a_smooth) + 0.5 * std(a_smooth);


[peaks, locs] = findpeaks(a_smooth, 'MinPeakHeight', threshold); %find peaks


minStepGap = 0.3; %seconds, time filter skip unrealistic fast steps
step_times = t(locs);
valid = [true; diff(step_times) > minStepGap];
step_count = sum(valid);

stride_length = 0.78;  % meters (average adult stride)
distance_m = step_count * stride_length;
fprintf("Estimated Distance: %.2f meters\n", distance_m);
fprintf("Steps counted in %.1f seconds: %d\n", log_duration, step_count);

hold on;
plot(t, a_smooth); 
plot(step_times(valid), a_smooth(locs(valid)), 'ro');
yline(threshold, 'r--');
title('Live Step Detection');
xlabel('Time (s)'); ylabel('Acceleration');
legend('Accel', 'Detected Steps', 'Threshold');
text(t(end)*0.6, max(a_smooth)*0.8, ...
     sprintf("Intensity: %s", intensity_label), ...
     'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', 'white');
hold off;