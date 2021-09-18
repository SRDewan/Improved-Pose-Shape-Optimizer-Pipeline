function [camWireframe, camBasisVecs] = rotatedCoords(keyptCtr)

wireframe = scalingFactor();
% visualizeWireframe3D(wireframe);

% As per the camera coordinate system:
% The X axis is along the width of the car from left to right (left
% headlight to right headlight).
% The Y axis is along the height of the car from top to bottom (roof top to wheel).
% The Z axis is along the length of the car from back (tail light to
% headlight) to front.

% We compare this with the world coordinate system to obtain the required
% rotation matrix. The negative sign indicates a 180 turn in direction.
R = [[0, 0, 1]', [0, -1, 0]', [1, 0, 0]'];
camWireframe = R * wireframe;

basisVecs = load('../parameters/vectors.txt');
camBasisVecs = [];

for i = 1:size(basisVecs, 1)
    temp = reshape(basisVecs(i, :), [3, keyptCtr]);
    temp = R * temp;
    camBasisVecs(i, :) = reshape(temp, [1, 3 * keyptCtr]);
end

% visualizeWireframe3D(camWireframe)
% disp(camBasisVecs);
