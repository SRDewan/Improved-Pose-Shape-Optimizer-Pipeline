function [scaledWireframe] = scalingFactor()

wireframe = load('../parameters/meanShape.txt');
wireframe = wireframe';
visualizeWireframe3D(wireframe);

% 1st column vector is for width which is along the X axis best estimated
% along the axis formed by L_F_WheelCenter and R_F_WheelCenter. The X axis
% is from the right to the left of the car.
% 2nd column vector is for length which is along the Y axis best estimated
% along the axis formed by L_TailLight and L_HeadLight. The Y axis is from
% the front to the back of the car.
% 3rd column vector is for height which is along the Z axis best estimated
% along the axis formed by R_B_RoofTop and R_B_WheelCenter. The Z axis is
% from the bottom to the top of the car.

Axes = [[wireframe(:, 1) - wireframe(:, 2)], [wireframe(:, 7) - wireframe(:, 5)], [wireframe(:, 14) - wireframe(:, 4)]];
% Length, width and height values are estimated by taking the norm of the above axes vectors
dims = vecnorm(Axes);
% The axes are supposed to be unit vectors and hence the division by the norm
Axes = Axes ./ dims;

avgDims = [1.6362, 3.8600, 1.5208];
scale = avgDims ./ dims;
scaledWireframe = wireframe .* scale';

% Axes = [[wireframe(:, 2) - wireframe(:, 1)], [wireframe(:, 7) - wireframe(:, 5)], [wireframe(:, 14) - wireframe(:, 4)]];
% dims = vecnorm(Axes);
% disp(dims);
% visualizeWireframe3D(wireframe);
