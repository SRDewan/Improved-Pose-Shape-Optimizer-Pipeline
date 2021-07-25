function [] = imgPlot(trackletInfo, pts, flag)

common = load('data').common;
K = common.K;

for i = 1:size(trackletInfo, 1)
	title = sprintf('%.0f,' , trackletInfo(i, 1:3));
	title = title(1:end - 1);      % strip final comma
	figure('NumberTitle', 'off', 'Name', title);

	img = imread(strcat('../data/', string(trackletInfo(i, 1)), '_', string(trackletInfo(i, 2)), '.png'));

	if flag
		imshow(img);
		hold on;
		plot(pts(2 * i - 1, :), pts(2 * i, :), 'linestyle', 'none', 'marker', 'o', 'MarkerFaceColor', 'b');

	else
		alignWireFrameImg = K * pts(3 * i - 2:3 * i, :);
		alignWireFrameImg = [alignWireFrameImg(1, :) ./ alignWireFrameImg(3,:); alignWireFrameImg(2, :) ./ alignWireFrameImg(3, :)];
		visualizeWireframe2D(img, alignWireFrameImg);
	end

	pause(1);
end

