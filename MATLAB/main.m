function [] = main()

common.K = [721.53,0,609.55;0,721.53,172.85;0,0,1];
common.avgDims = [1.6362, 3.8600, 1.5208];
save('data', 'common');

seq = [ 2,10,  4,  8, 2, 9]; %Sequences
frm = [98, 1,197,126,90,42]; %Frames
id  = [ 1, 0, 20, 12, 1, 1]; %CarID's

addpath('../devkit/matlab/');
[groundTruth, trackletInfo] = getObjsInfo('../data/training/label_02', seq, frm, id);

[alignedFrames, alignedVecs] = alignFrame(groundTruth, trackletInfo);
%imgPlot(trackletInfo, alignedFrames, false);

keyPts = load('../parameters/result_KP.txt');
[alignedKeypts, confidences] = alignKeypts(trackletInfo, keyPts);
weights = kpWeights(trackletInfo, confidences);
%imgPlot(trackletInfo, alignedKeypts, true);

poseOpt(groundTruth, trackletInfo, alignedKeypts, weights);
