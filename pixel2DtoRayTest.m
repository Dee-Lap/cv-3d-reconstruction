[camCenter, rayDir] = pixel2DtoRay(pts2D, vue2);

% pick joint 1, check the original 3D point lies along the ray
vecToPoint = pts3D(1,:) - camCenter;
t = norm(vecToPoint);                     % rough distance guess
predictedDir = vecToPoint / norm(vecToPoint);

dot(predictedDir, rayDir(1,:))   % should be very close to 1 if correct

for i = 1:12
    vecToPoint = pts3D(i,:) - camCenter;
    predictedDir = vecToPoint / norm(vecToPoint);
    fprintf('Joint %d dot product: %.6f\n', i, dot(predictedDir, rayDir(i,:)));
end