function [] = imgPlot(trackletInfo, pts, type, workingDir)

common = load('data').common;
K = common.K;

for i = 1:size(trackletInfo, 1)
	figTitle = sprintf('%.0f,' , trackletInfo(i, 1:3));
	figTitle = figTitle(1:end - 1);      % strip final comma
	figure('NumberTitle', 'off', 'Name', figTitle);

	if type == 6
		img = imread(sprintf('../data/training/image_02/%04d/%06d.png', trackletInfo(i, 1), trackletInfo(i, 2)));

	else
		img = imread(strcat('../data/', string(trackletInfo(i, 1)), '_', string(trackletInfo(i, 2)), '.png'));
	end

	if type == 5
		subplot(2, 2, 1);
		imshow(img);
		hold on;
		plot(common.alignedKeypts(2 * i - 1, :), common.alignedKeypts(2 * i, :), 'linestyle', 'none', 'marker', 'o', 'MarkerFaceColor', 'b');
		title("Keypoints");

		subplot(2, 2, 2);
		alignWireFrameImg = K * common.alignedFrames(3 * i - 2:3 * i, :);
		alignWireFrameImg = [alignWireFrameImg(1, :) ./ alignWireFrameImg(3,:); alignWireFrameImg(2, :) ./ alignWireFrameImg(3, :)];
		visualizeWireframe2D(img, alignWireFrameImg);
		title("Approx Alignment");

		subplot(2, 2, 3);
		alignWireFrameImg = K * common.poseFrames(3 * i - 2:3 * i, :);
		alignWireFrameImg = [alignWireFrameImg(1, :) ./ alignWireFrameImg(3,:); alignWireFrameImg(2, :) ./ alignWireFrameImg(3, :)];
		visualizeWireframe2D(img, alignWireFrameImg);
		title("Pose Optimized Alignment");

		subplot(2, 2, 4);
		alignWireFrameImg = K * common.shapeFrames(3 * i - 2:3 * i, :);
		alignWireFrameImg = [alignWireFrameImg(1, :) ./ alignWireFrameImg(3,:); alignWireFrameImg(2, :) ./ alignWireFrameImg(3, :)];
		visualizeWireframe2D(img, alignWireFrameImg);
		title("Shape Optimized Alignment");

	elseif type == 1 
		imshow(img);
		hold on;
		plot(pts(2 * i - 1, :), pts(2 * i, :), 'linestyle', 'none', 'marker', 'o', 'MarkerFaceColor', 'b');

	else
		alignWireFrameImg = K * pts(3 * i - 2:3 * i, :);
		alignWireFrameImg = [alignWireFrameImg(1, :) ./ alignWireFrameImg(3,:); alignWireFrameImg(2, :) ./ alignWireFrameImg(3, :)];
		visualizeWireframe2D(img, alignWireFrameImg);

		if type == 6
			F = getframe;
			% save the image
			save_file_name = sprintf('%s/%d.jpg', workingDir, trackletInfo(i, 2));
			imwrite(F.cdata, save_file_name);
			close(figure);
		end
	end

	pause(1);
end

