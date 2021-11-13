function [] = imgPlot(trackletInfo, pts, type, workingDir)

common = load('data').common;
K = common.K;
fileID = fopen('../parameters/annotation.txt', 'w');

for i = 1:size(trackletInfo, 1)
	figTitle = sprintf('%.0f,' , trackletInfo(i, 1:3));
	figTitle = figTitle(1:end - 1);      % strip final comma
	figure('NumberTitle', 'off', 'Name', figTitle);

	img = imread(sprintf('../data/training/image_02/%04d/%06d.png', trackletInfo(i, 1), trackletInfo(i, 2)));

	if type == 3
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

	elseif type == 4 
		img = imcrop(img, [trackletInfo(i, 4), trackletInfo(i, 5), trackletInfo(i, 6) - trackletInfo(i, 4), trackletInfo(i, 7) - trackletInfo(i, 5)]);
		img = imresize(img, [64, 64]);
		imshow(img);
		hold on;
		plot(pts(2 * i - 1, :), pts(2 * i, :), 'linestyle', 'none', 'marker', 'o', 'MarkerFaceColor', 'b');

		[xclick, yclick] = getpts;
		frameAnnotation = [xclick'; yclick'; ones(1, size(xclick, 1))];
		for j=1:size(frameAnnotation, 2)
			fprintf(fileID, '%f %f %f ', frameAnnotation(1:3, j));
		end
		fprintf(fileID, '\n');

	else
		alignWireFrameImg = K * pts(3 * i - 2:3 * i, :);
		alignWireFrameImg = [alignWireFrameImg(1, :) ./ alignWireFrameImg(3,:); alignWireFrameImg(2, :) ./ alignWireFrameImg(3, :)];
		visualizeWireframe2D(img, alignWireFrameImg);
	end

	if ~isempty(workingDir)
		F = getframe;
		% save the image
		save_file_name = sprintf('%s/%d.jpg', workingDir, trackletInfo(i, 2));
		imwrite(F.cdata, save_file_name);
		close(figure);
		close all;
	end

	pause(1);
end

fclose(fileID);
