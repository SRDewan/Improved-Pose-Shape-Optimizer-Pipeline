function [finalWireFrames, allFinalBasisVecs] = alignFrame(groundTruth, trackletInfo)

common = load('data').common;
K = common.K;

[wireFrame, basisVecs] = rotatedCoords();
[trans, err] = mobili(groundTruth, trackletInfo);
finalWireFrames = [];
allFinalBasisVecs = [];

for i = 1:size(trackletInfo, 1)
	[alignWireFrame, alignBasisVecs] = rotEst(groundTruth(i, :), trackletInfo(i, :), wireFrame, basisVecs);
	alignWireFrame = alignWireFrame + trans(i, :)';
	finalWireFrames = [finalWireFrames; alignWireFrame];

	finalBasisVecs = alignBasisVecs;
	allFinalBasisVecs = [allFinalBasisVecs; finalBasisVecs];

	alignWireFrameImg = K * alignWireFrame;
	alignWireFrameImg = [alignWireFrameImg(1, :) ./ alignWireFrameImg(3, :); alignWireFrameImg(2, :) ./ alignWireFrameImg(3, :)];
end
