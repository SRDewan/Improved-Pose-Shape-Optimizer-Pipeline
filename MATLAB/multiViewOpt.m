function [multiFrames] = multiViewOpt(groundTruth, trackletInfo, alignedKeypts, weights, translation, rotation, shapeLambdas)

multiFrames = [];
views = size(groundTruth, 1);

common = load('data').common;
avgDims = [common.avgDims(2), common.avgDims(3), common.avgDims(1)];
K = common.K;
pts = common.keyptCtr;
obs = common.keyptCtr;

[trans, err] = mobili(groundTruth, trackletInfo);
[alignedFrames, alignedVecs] = alignFrame(groundTruth, trackletInfo);

file = fopen('../ceres/ceres_input_multiViewAdjuster.txt', 'w');
fprintf(file, '%d %d %d %d\n', [views, pts, obs, 42]); % remove 42 for own version, keep for Sudhansh version
fprintf(file, '%f %f %f\n', avgDims);
fprintf(file, '%f %f %f %f %f %f %f %f %f\n', reshape(K', [1, 9]));

for i = 1:size(groundTruth, 1)
	fprintf(file, '%f %f %f\n', trans(i, :));
end

for i = 1:size(groundTruth, 1)
	fprintf(file, '%f %f\n', alignedKeypts(2 * i - 1:2 * i, :));
end

for i = 1:size(groundTruth, 1)
	fprintf(file, '%f\n', weights(i, :)');
end

for i = 1:size(groundTruth, 1)
	fprintf(file, '%f %f %f\n', alignedFrames(3 * i - 2:3 * i, :));
end

for i = 1:size(groundTruth, 1)
	for j=1:42
        	for k=1:3:108
            		fprintf(file, '%f %f %f ', alignedVecs(42 * (i - 1) + j, k : k + 2));
        	end
        	fprintf(file, "\n");
	end
end

lambda = mean(shapeLambdas);
for j=1:size(lambda, 2)
	fprintf(file, '%f ', lambda(j));
end

for i = 1:size(groundTruth, 1)
	fprintf(file, '%f %f %f %f %f\n', rotation(i, :)');
end

for i = 1:size(groundTruth, 1)
	fprintf(file, '%f %f %f %f %f\n', translation(i, :)');
end

fclose(file);

cmd = 'cd ../ceres; ./multiViewAdjuster; cd -';
system(cmd);

data = importdata('../ceres/ceres_output_multiViewAdjuster.txt');
for i = 1:size(groundTruth, 1)
	idx = (i - 1) * common.keyptCtr + 1;
	multiFrames = [multiFrames; data(idx:idx + common.keyptCtr - 1, :)'];
end
