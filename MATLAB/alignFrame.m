function [] = alignFrame()

seq = [ 2,10,  4,  8, 2, 9]; %Sequences
frm = [98, 1,197,126,90,42]; %Frames
id  = [ 1, 0, 20, 12, 1, 1]; %CarID's
K = [721.53,0,609.55;0,721.53,172.85;0,0,1]; %Intrinsics

addpath('../devkit/matlab/');
[groundTruth, trackletInfo] = getObjsInfo('../data/training/label_02', seq, frm, id);
[wireFrame, basisVecs] = rotatedCoords();
[trans, err] = mobili(groundTruth, trackletInfo);
offset = 90;

for i = 1:size(trackletInfo, 1)
	[alignWireFrame, alignBasisVecs] = rotEst(groundTruth(i, :), trackletInfo(i, :), wireFrame, basisVecs);
	alignWireFrame = alignWireFrame + trans(i, :)';
	alignWireFrame = K * alignWireFrame;
	finalWireFrame = [alignWireFrame(1, :) ./ alignWireFrame(3, :); alignWireFrame(2, :) ./ alignWireFrame(3, :)];

	title = sprintf('%.0f,' , trackletInfo(i, 1:3));
	title = title(1:end - 1);      % strip final comma
	figure('NumberTitle', 'off', 'Name', title);

	img = imread(strcat('../data/', string(trackletInfo(i, 1)), '_', string(trackletInfo(i, 2)), '.png'));
	visualizeWireframe2D(img, finalWireFrame);
	pause(1);
end
