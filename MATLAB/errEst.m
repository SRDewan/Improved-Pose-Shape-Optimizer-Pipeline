function [reprojErrs] = errEst(groundTruth, trackletInfo)

common = load('data').common;
reprojErrs = [];
viewptErrs = [];
labels = {};

for i = 1:size(groundTruth, 1)

	lengthVec = [];
	viewptErr = [];
	ry = trackletInfo(i, 8) + common.offset * pi / 180;
	if ry > pi
		ry = 2 * pi - ry;
	elseif ry < 0
		ry = -ry;
	end

	lengthVec = [lengthVec, (common.alignedFrames(3 * i - 2:3 * i, 1) + common.alignedFrames(3 * i - 2:3 * i, 2)) / 2 - (common.alignedFrames(3 * i - 2:3 * i, 3) + common.alignedFrames(3 * i - 2:3 * i, 4)) / 2];
	viewptErr = [viewptErr, acos(dot(lengthVec(:, end), [0 0 1]) ./ norm(lengthVec(:, end))) - ry];
	approxFrames = common.K * common.alignedFrames(3 * i - 2:3 * i, :);
	approxFrames = [approxFrames(1, :) ./ approxFrames(3, :); approxFrames(2, :) ./ approxFrames(3, :)];

	lengthVec = [lengthVec, (common.poseFrames(3 * i - 2:3 * i, 1) + common.poseFrames(3 * i - 2:3 * i, 2)) / 2 - (common.poseFrames(3 * i - 2:3 * i, 3) + common.poseFrames(3 * i - 2:3 * i, 4)) / 2];
	viewptErr = [viewptErr, acos(dot(lengthVec(:, end), [0 0 1]) ./ norm(lengthVec(:, end))) - ry];
	poseFrames = common.K * common.poseFrames(3 * i - 2:3 * i, :);
	poseFrames = [poseFrames(1, :) ./ poseFrames(3, :); poseFrames(2, :) ./ poseFrames(3, :)];

	lengthVec = [lengthVec, (common.shapeFrames(3 * i - 2:3 * i, 1) + common.shapeFrames(3 * i - 2:3 * i, 2)) / 2 - (common.shapeFrames(3 * i - 2:3 * i, 3) + common.shapeFrames(3 * i - 2:3 * i, 4)) / 2];
	viewptErr = [viewptErr, acos(dot(lengthVec(:, end), [0 0 1]) ./ norm(lengthVec(:, end))) - ry];
	shapeFrames = common.K * common.shapeFrames(3 * i - 2:3 * i, :);
	shapeFrames = [shapeFrames(1, :) ./ shapeFrames(3, :); shapeFrames(2, :) ./ shapeFrames(3, :)];

	reprojErr = [sum(sum(abs(approxFrames(:, :) - common.alignedKeypts(2 * i - 1:2 * i, :)))), sum(sum(abs(poseFrames(:, :) - common.alignedKeypts(2 * i - 1:2 * i, :)))), sum(sum(abs(shapeFrames(:, :) - common.alignedKeypts(2 * i - 1:2 * i, :))))];
	reprojErrs = [reprojErrs; reprojErr];
	viewptErrs = [viewptErrs; abs(viewptErr) * 180 / pi];

	label = sprintf('%.0f,', trackletInfo(i, 1:3));
	labels{end + 1} = label(1:end - 1);
end

figure();
reprojErrBar = bar(reprojErrs);
set(gca, 'xticklabel', labels);
set(reprojErrBar, {'DisplayName'}, {'Approx','Pose','Shape'}');
legend();
title('Reprojection Error');
xlabel('Vehicles');
ylabel('Error');

figure();
viewptErrBar = bar(viewptErrs);
set(gca, 'xticklabel', labels);
set(viewptErrBar, {'DisplayName'}, {'Approx','Pose','Shape'}');
legend();
title('Viewpoint Error');
xlabel('Vehicles');
ylabel('Error (in degrees)');
