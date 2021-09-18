function [scaledWireframe] = scalingFactor()

common = load('data').common;
avgDims = common.avgDims;

wireframe = load('../parameters/meanShape.txt');
wireframe = wireframe';
% visualizeWireframe3D(wireframe);

% 1st column vector is for length which is along the X axis best estimated
% along the axis formed by L_B_Bumper and L_F_Bumper. The X axis
% is from the back to the front of the car.
% 2nd column vector is for height which is along the Y axis best estimated
% along the axis formed by L_B_RoofTop and projection of L_B_RoofTop on the 
% wheel plane. The Y axis is from the bottom to the top of the car.
% 3rd column vector is for width which is along the Z axis best estimated
% along the axis formed by L_B_WheelCenter and R_B_WheelCenter. The Z axis
% is from the left to the right of the car.

proj = planeProj([wireframe(:, 24:25), wireframe(:, 7)], wireframe(:, 14));
Axes = [[wireframe(:, 18) - wireframe(:, 11)], [wireframe(:, 14) - proj], [wireframe(:, 19) - wireframe(:, 1)]];
% Length, width and height values are estimated by taking the norm of the above axes vectors
dims = vecnorm(Axes);
% The axes are supposed to be unit vectors and hence the division by the norm
Axes = Axes ./ dims;

scale = avgDims ./ dims;
% We obtain a scaling factor of [0.2941, 0.3458, 0.4491]
% disp(scale);
scaledWireframe = wireframe .* scale';

proj = planeProj([scaledWireframe(:, 24:25), scaledWireframe(:, 7)], scaledWireframe(:, 14));
Axes = [[scaledWireframe(:, 18) - scaledWireframe(:, 11)], [scaledWireframe(:, 14) - proj], [scaledWireframe(:, 19) - scaledWireframe(:, 1)]];
dims = vecnorm(Axes);
% disp(dims);
% visualizeWireframe3D(scaledWireframe);
