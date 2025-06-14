load('distance_tracker.mat')

A1 = Position.latitude(1) * 3.142/180;
A2 = Position.latitude(end) * 3.142/180;
B1 = Position.longitude(1) * 3.142/180;
B2 = Position.longitude(end) * 3.142/180;


%Haversine formula
R = 6371;
d = 2 * R * asin(sqrt(sin((A2 - A1)/2).^2)+ cos(A1) * cos(A2) * sin((B2 - B1)/2).^2);
disp(d);


