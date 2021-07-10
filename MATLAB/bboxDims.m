function [dims] = bboxDims(trackletInfo)

dims = [];
for i = 1:size(trackletInfo, 1)
	currDims = [trackletInfo(i, 6) - trackletInfo(i, 4) trackletInfo(i, 7) - trackletInfo(i, 5)];
	dims = [dims; currDims];
end
