% triangulate2RaysTest.m
load('Subject4-Session3-Take4_mocapJoints.mat');
load('vue2CalibInfo.mat');
load('vue4CalibInfo.mat');

mocapFnum = 1000;
x = mocapJoints(mocapFnum,:,1);
y = mocapJoints(mocapFnum,:,2);
z = mocapJoints(mocapFnum,:,3);
pts3D = [x', y', z'];

pts2D_vue2 = project3Dto2D(pts3D, vue2);
pts2D_vue4 = project3Dto2D(pts3D, vue4);

[c1, d1] = pixel2DtoRay(pts2D_vue2, vue2);
[c2, d2] = pixel2DtoRay(pts2D_vue4, vue4);

reconstructed = zeros(12,3);
for j = 1:12
    reconstructed(j,:) = triangulate2Rays(c1, d1(j,:), c2, d2(j,:));
end

reconstructed
pts3D