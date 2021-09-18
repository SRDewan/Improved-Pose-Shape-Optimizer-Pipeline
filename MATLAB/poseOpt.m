function [translation, rotation, poseFrames] = poseOpt(groundTruth, trackletInfo, alignedKeypts, weights)

poseFrames = [];
translation = [];
rotation = [];
views = 1;

common = load('data').common;
avgDims = [common.avgDims(3), common.avgDims(2), common.avgDims(1)];
K = common.K;
pts = common.keyptCtr;
obs = common.keyptCtr;
lambda = [0.0208000000000000,0.00970000000000000,0.00720000000000000,0.00570000000000000,0.00470000000000000,0.00330000000000000,0.00210000000000000,0.00160000000000000,0.00100000000000000,0.000900000000000000,0.000800000000000000,0.000800000000000000,0.000700000000000000,0.000600000000000000,0.000500000000000000,0.000500000000000000,0.000400000000000000,0.000400000000000000,0.000400000000000000,0.000300000000000000,0.000300000000000000,0.000300000000000000,0.000300000000000000,0.000300000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000200000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000,0.000100000000000000];

[trans, err] = mobili(groundTruth, trackletInfo);
[alignedFrames, alignedVecs] = alignFrame(groundTruth, trackletInfo);

for i = 1:size(trans, 1)
	file = fopen('../ceres/ceres_input_singleViewPoseAdjuster.txt', 'w');
	fprintf(file, '%d %d %d\n', [views, pts, obs]);
	fprintf(file, '%f %f %f\n', trans(i, :));
	fprintf(file, '%f %f %f\n', avgDims);
	fprintf(file, '%f %f %f %f %f %f %f %f %f\n', reshape(K', [1, 9]));

	fprintf(file, '%f %f\n', alignedKeypts(2 * i - 1:2 * i, :));
	fprintf(file, '%f\n', weights(i, :)');
	fprintf(file, '%f %f %f\n', alignedFrames(3 * i - 2:3 * i, :));

	for j=1:5
		fprintf(file, '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', alignedVecs(5 * (i - 1) + j, :));
	    end

	fprintf(file, '%f %f %f %f %f\n', lambda);
	fclose(file);

	cmd = 'cd ../ceres; ./singleViewPoseAdjuster; cd -';
	system(cmd);

	data = importdata('../ceres/ceres_output_singleViewPoseAdjuster.txt');
	rotParams = data(1:9);
	transParams = data(10:12);
	R = reshape(rotParams, [3 3]);
	poseFrame = (R * alignedFrames(3 * i - 2:3 * i, :)) + transParams;

	translation = [translation; transParams'];
	rotation = [rotation; rotParams'];
	poseFrames = [poseFrames; poseFrame];
end
