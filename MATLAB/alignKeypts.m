function [alignedKeypts, confidences] = alignKeypts(trackletInfo, keyPts, keyptCtr)

alignedKeypts = [];
confidences = [];
scaling = bboxDims(trackletInfo) ./ 64;

for i = 1:size(keyPts, 1)
    temp = reshape(keyPts(i, :), [3, keyptCtr]);
    ptCoords = [temp(1, :) .* scaling(i, 1) + trackletInfo(i, 4); temp(2, :) .* scaling(i, 2) + trackletInfo(i, 5)];
    alignedKeypts = [alignedKeypts; ptCoords];
    confidences = [confidences; temp(3, :)];
end
