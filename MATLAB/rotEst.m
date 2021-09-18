function [rotWireframe, rotBasisVecs] = rotEst(groundTruth, trackletInfo, wireFrame, basisVecs)

common = load('data').common;
keyptCtr = common.keyptCtr;
common.offset = 90;
save('data', 'common');

ry = trackletInfo(8) + common.offset * pi / 180;
R = [cos(ry) 0 sin(ry); 0 1 0; -sin(ry) 0 cos(ry)];

rotWireframe = R * wireFrame;
rotBasisVecs = [];

for i = 1:size(basisVecs, 1)
    temp = reshape(basisVecs(i, :), [3, keyptCtr]);
    temp = R * temp;
    rotBasisVecs = [rotBasisVecs; reshape(temp, [1, 3 * keyptCtr])];
end
