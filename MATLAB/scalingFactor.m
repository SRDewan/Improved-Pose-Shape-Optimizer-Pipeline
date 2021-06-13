function [scaledWireframe] = scalingFactor()

wireframe = load('../parameters/meanShape.txt');
wireframe = wireframe';
% visualizeWireframe3D(wireframe);

% 1st column vector is for width which is along the X axis best estimated
% along the axis formed by L_F_WheelCenter and R_F_WheelCenter. The X axis
% is from the right to the left of the car.
% 2nd column vector is for length which is along the Y axis best estimated
% along the axis formed by L_TailLight and L_HeadLight. The Y axis is from
% the front to the back of the car.
% 3rd column vector is for height which is along the Z axis best estimated
% along the axis formed by R_F_RoofTop and projection of R_F_RoofTop on the 
% wheel plane. The Z axis is from the bottom to the top of the car.

proj = planeProj(wireframe(:, 1:3), wireframe(:, 12));
Axes = [[wireframe(:, 1) - wireframe(:, 2)], [wireframe(:, 7) - wireframe(:, 5)], [wireframe(:, 12) - proj]];
% Length, width and height values are estimated by taking the norm of the above axes vectors
dims = vecnorm(Axes);
% The axes are supposed to be unit vectors and hence the division by the norm
Axes = Axes ./ dims;

avgDims = [1.6362, 3.8600, 1.5208];
scale = avgDims ./ dims;
% We obtain a scaling factor of [0.2941, 0.3458, 0.4491]
% disp(scale);
scaledWireframe = wireframe .* scale';

proj = planeProj(scaledWireframe(:, 1:3), scaledWireframe(:, 12));
Axes = [[scaledWireframe(:, 1) - scaledWireframe(:, 2)], [scaledWireframe(:, 7) - scaledWireframe(:, 5)], [scaledWireframe(:, 12) - proj]];
dims = vecnorm(Axes);
% disp(dims);
% visualizeWireframe3D(scaledWireframe);
