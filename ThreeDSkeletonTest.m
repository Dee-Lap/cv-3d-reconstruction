load('Subject4-Session3-Take4_mocapJoints.mat');
load('vue2CalibInfo.mat');
load('vue4CalibInfo.mat');figure;

drawSkeleton(pts3D, 'b');        % original in blue
% reconstructed from your triangulation, computed the same way as before
pts2D_vue2 = project3Dto2D(pts3D, vue2);
pts2D_vue4 = project3Dto2D(pts3D, vue4);
[c1, d1] = pixel2DtoRay(pts2D_vue2, vue2);
[c2, d2] = pixel2DtoRay(pts2D_vue4, vue4);
reconstructed = zeros(12,3);
for j = 1:12
    reconstructed(j,:) = triangulate2Rays(c1, d1(j,:), c2, d2(j,:));
end
drawSkeleton(reconstructed, 'r');  % reconstructed in red
legend('Original', 'Reconstructed');
title(sprintf('Frame %d: original vs reconstructed 3D skeleton', mocapFnum));
axis equal;