function [weights] = kpWeights(trackletInfo, confidences)

common = load('data').common;
kpLookup = importdata('../parameters/kpLookup_azimuth.mat');
weights = [];
wkpsWeight = 0.7;
min = 0.000001;

for i = 1:size(confidences, 1)
	azimuth = round(trackletInfo(i, 8) * 180 / pi + common.offset);
	if(azimuth < 1)
		azimuth = 360 + azimuth;
	end

	kpOcc = kpLookup(round(azimuth), :);
	kpOcc = kpOcc ./ sum(kpOcc);
	temp = confidences(i, :) .* wkpsWeight + kpOcc .* (1 - wkpsWeight);

	for j = 1:size(temp, 2)
		if(temp(j) < min)
			temp(j) = min;
		end
	end

	weights = [weights; temp];
end
