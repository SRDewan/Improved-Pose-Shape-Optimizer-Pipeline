function [finalWireFrames] = alignFrame(groundTruth, trackletInfo)

common = load('data').common;
K = common.K;

[wireFrame, basisVecs] = rotatedCoords();
[trans, err] = mobili(groundTruth, trackletInfo);
finalWireFrames = [];

for i = 1:size(trackletInfo, 1)
	[alignWireFrame, alignBasisVecs] = rotEst(groundTruth(i, :), trackletInfo(i, :), wireFrame, basisVecs);
	alignWireFrame = alignWireFrame + trans(i, :)';
	alignWireFrame = K * alignWireFrame;
	finalWireFrame = [alignWireFrame(1, :) ./ alignWireFrame(3, :); alignWireFrame(2, :) ./ alignWireFrame(3, :)];
	finalWireFrames = [finalWireFrames; finalWireFrame];
end
