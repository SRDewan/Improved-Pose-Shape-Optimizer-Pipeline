function [] = multiView(seqs, startFrm, endFrm, ids)

common = load('data').common;
addpath('../devkit/matlab/');

for i = 1:size(seqs, 2)
	numViews = endFrm(i) - startFrm(i) + 1;
	seq = seqs(i) + zeros(1, numViews);
	frm = startFrm(i):endFrm(i);
	id = ids(i) + zeros(1, numViews);

	[groundTruth, trackletInfo] = getObjsInfo('../data/training/label_02', seq, frm, id);

	keyPts = getKeyPts(seq, frm, id, common.keyptCtr, false);
	[alignedKeypts, confidences] = alignKeypts(trackletInfo, keyPts, common.keyptCtr);
	weights = kpWeights(trackletInfo, confidences);
	common.alignedKeypts = alignedKeypts;
	%imgPlot(trackletInfo, alignedKeypts, 1, '');
	%imgPlot(trackletInfo, alignedKeypts, 4, '');

	[alignedFrames, alignedVecs] = alignFrame(groundTruth, trackletInfo);
	[translation, rotation, poseFrames] = poseOpt(groundTruth, trackletInfo, alignedKeypts, weights);
	[shapeFrames, shapeLambdas] = shapeOpt(groundTruth, trackletInfo, alignedKeypts, weights, translation, rotation);

	common.alignedFrames = alignedFrames;
	common.poseFrames = poseFrames;
	common.shapeFrames = shapeFrames;

	workingDir = sprintf('../results/multiView/%d_%d_%d_%d', seqs(i), startFrm(i), endFrm(i), ids(i));
	mkdir(workingDir);
	imgPlot(trackletInfo, shapeFrames, 2, workingDir);
	cmd = 'ffmpeg -framerate 4 -start_number ' + string(startFrm(i)) + ' -i ' + string(workingDir) + '/%d.jpg -vcodec mpeg4 ' + string(workingDir) + '/video.mp4';
	system(cmd);

	[multiOptFrames] = multiViewOpt(groundTruth, trackletInfo, alignedKeypts, weights, translation, rotation, shapeLambdas);
	common.multiOptFrames = multiOptFrames;
	save('data', 'common');
	%imgPlot(trackletInfo, [], 3, '');

	optDir = sprintf('../results/multiView/%d_%d_%d_%d_Opt', seqs(i), startFrm(i), endFrm(i), ids(i));
	mkdir(optDir);
	imgPlot(trackletInfo, multiOptFrames, 2, optDir);
	cmd = 'ffmpeg -framerate 4 -start_number ' + string(startFrm(i)) + ' -i ' + string(optDir) + '/%d.jpg -vcodec mpeg4 ' + string(optDir) + '/video.mp4';
	system(cmd);
	%errEst(groundTruth, trackletInfo);
end
