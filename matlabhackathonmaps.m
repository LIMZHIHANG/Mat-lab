clear
close all
load test2.mat
lat = Position.latitude;
lon = Position.longitude;
spd = Position.speed;

nBins = 10;
binSpacing = (max(spd) - min(spd))/nBins; 
binRanges = min(spd):binSpacing:max(spd)-binSpacing; 

binRanges(end+1) = inf;

[~, spdBins] = histc(spd, binRanges);


lat = lat';
lon = lon';
spdBins = spdBins';

s = geoshape();

for k = 1:nBins
    
    latValid = nan(1, length(lat));
    latValid(spdBins==k) = lat(spdBins==k);
    
    lonValid = nan(1, length(lon));
    lonValid(spdBins==k) = lon(spdBins==k);    
    transitions = [diff(spdBins) 0];
    insertionInd = find(spdBins==k & transitions~=0) + 1;
    latSeg = zeros(1, length(latValid) + length(insertionInd));
    latSeg(insertionInd + (0:length(insertionInd)-1)) = lat(insertionInd);
    latSeg(~latSeg) = latValid;
    
    lonSeg = zeros(1, length(lonValid) + length(insertionInd));
    lonSeg(insertionInd + (0:length(insertionInd)-1)) = lon(insertionInd);
    lonSeg(~lonSeg) = lonValid;
    s(k) = geoshape(latSeg, lonSeg);
    
end

wm = webmap('Open Street Map');
initlat = lat(1,1);
initlon = lon(1,1);
finallat = lat(1,end);
finallon = lon(1,end);
namestart = 'start Point';
nameend = 'end point';
wmmarker(initlat, initlon, 'FeatureName', namestart);
wmmarker(finallat, finallon, 'FeatureName', nameend);
colors = copper(nBins);
wmline(s, 'Color', colors, 'Width', 7);

binRanges2=binRanges(1,1:10);
binRanges2_kmh=binRanges2*3.6;
y=linspace(1,10,10);
scatter(y,binRanges2_kmh,[],colors,'filled')
xlabel('speed bins and color')
ylabel('speed(km/h)')