function [poseFrames] = poseOpt(groundTruth, trackletInfo, alignedKeypts, weights)

poseFrames = [];
views = 1;
pts = 14;
obs = 14;

common = load('data').common;
avgDims = circshift(common.avgDims, [0, 1]);
K = common.K;
lambda = [0.250000 0.270000 0.010000 -0.080000 -0.050000];

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
	poseFrames = [poseFrames; poseFrame];
end
