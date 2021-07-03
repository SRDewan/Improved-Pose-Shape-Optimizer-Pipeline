function [predicted, err] = mobili(groundTruth, trackletInfo)

K = [721.53,0,609.55;0,721.53,172.85;0,0,1]; %Intrinsics
n = [0; -1; 0]; %ground plane normal
avgDims = [1.6362, 3.8600, 1.5208];
h = avgDims(3); %camera height

predicted = [];
err = [];

for i = 1:size(trackletInfo, 1)
	b = [(trackletInfo(i, 4) + trackletInfo(i, 6)) / 2; trackletInfo(i, 7); 1];
	B = (-h * inv(K) * b) ./ (n' * inv(K) * b);
	B = B + [0; -avgDims(3) / 2; avgDims(2) / 2];

	predicted = [predicted; B'];
	err = [err; abs(B' - groundTruth(i, 4:6))];
end
