function [projection] = planeProj(plane, P)

A = plane(:, 1) - plane(:, 2);
B = plane(:, 1) - plane(:, 3);
normal = cross(A, B);
normal = normal ./ vecnorm(normal); 
projection = P - dot(P - plane(:, 1), normal) .* normal;
