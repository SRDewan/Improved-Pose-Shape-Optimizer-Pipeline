function [] = multiView(seqs, startFrm, endFrm, ids)

common = load('data').common;
addpath('../devkit/matlab/');

for i = 1:size(seqs, 2)
	numViews = endFrm(i) - startFrm(i) + 1;
	seq = seqs(i) + zeros(1, numViews);
	frm = startFrm(i):endFrm(i);
	id = ids(i) + zeros(1, numViews);

	[groundTruth, trackletInfo] = getObjsInfo('../data/training/label_02', seq, frm, id);

	keyPts = getKeyPts(seq, frm, id, common.keyptCtr);
	[alignedKeypts, confidences] = alignKeypts(trackletInfo, keyPts, common.keyptCtr);
	weights = kpWeights(trackletInfo, confidences);

	[translation, rotation, poseFrames] = poseOpt(groundTruth, trackletInfo, alignedKeypts, weights);
	[shapeFrames, shapeLambdas] = shapeOpt(groundTruth, trackletInfo, alignedKeypts, weights, translation, rotation);

	%workingDir = sprintf('../results/multiView/%d_%d_%d_%d', seqs(i), startFrm(i), endFrm(i), ids(i));
	%mkdir(workingDir);
	%imgPlot(trackletInfo, shapeFrames, 6, workingDir);

	[multiOptFrames] = multiViewOpt(groundTruth, trackletInfo, alignedKeypts, weights, translation, rotation, shapeLambdas);
	common.multiOptFrames = multiOptFrames;
	save('data', 'common');
	disp(size(multiOptFrames));

	optDir = sprintf('../results/multiView/%d_%d_%d_%d_Opt', seqs(i), startFrm(i), endFrm(i), ids(i));
	mkdir(optDir);
	imgPlot(trackletInfo, multiOptFrames, 6, optDir);
	%cmd = sprintf('ffmpeg -framerate 25 -i %s/*.jpg -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p %s/video.mp4', workingDir, workingDir)
	%system(cmd);
end
