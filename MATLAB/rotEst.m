function [rotWireframe, rotBasisVecs] = rotEst(groundTruth, trackletInfo, wireFrame, basisVecs)

offset = 90;
ry = trackletInfo(8) + offset * pi / 180;
R = [cos(ry) 0 sin(ry); 0 1 0; -sin(ry) 0 cos(ry)];

rotWireframe = R * wireFrame;

for i = 1:size(basisVecs, 1)
    temp = reshape(basisVecs(i, :), [3, 14]);
    temp = R * temp;
    rotBasisVecs(i, :) = reshape(temp, [1, 42]);
end
