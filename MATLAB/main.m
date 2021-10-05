function [] = main()

common.K = [721.53,0,609.55;0,721.53,172.85;0,0,1];
common.avgDims = [3.8600, 1.5208, 1.6362];
common.keyptCtr = 36;
common.offset = 90;
save('data', 'common');

seq = [ 2,10,  4,  8, 2, 9]; %Sequences
frm = [98, 1,197,126,90,42]; %Frames
id  = [ 1, 0, 20, 12, 1, 1]; %CarID's

addpath('../devkit/matlab/');
[groundTruth, trackletInfo] = getObjsInfo('../data/training/label_02', seq, frm, id);

[alignedFrames, alignedVecs] = alignFrame(groundTruth, trackletInfo);
% imgPlot(trackletInfo, alignedFrames, 0, '');

keyPts = getKeyPts(seq, frm, id, common.keyptCtr);
[alignedKeypts, confidences] = alignKeypts(trackletInfo, keyPts, common.keyptCtr);
weights = kpWeights(trackletInfo, confidences);
% imgPlot(trackletInfo, alignedKeypts, 1, '');

[translation, rotation, poseFrames] = poseOpt(groundTruth, trackletInfo, alignedKeypts, weights);

[shapeFrames, shapeLambdas] = shapeOpt(groundTruth, trackletInfo, alignedKeypts, weights, translation, rotation);

common.alignedKeypts = alignedKeypts;
common.alignedFrames = alignedFrames;
common.poseFrames = poseFrames;
common.shapeFrames = shapeFrames;
save('data', 'common');

%imgPlot(trackletInfo, common.poseFrames, 0, '');
imgPlot(trackletInfo, [], 5, '');

errEst(groundTruth, trackletInfo);
