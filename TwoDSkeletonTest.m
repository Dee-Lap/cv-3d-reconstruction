load('Subject4-Session3-Take4_mocapJoints.mat');
load('vue2CalibInfo.mat');

mocapFnum = 17593;
x = mocapJoints(mocapFnum,:,1);
y = mocapJoints(mocapFnum,:,2);
z = mocapJoints(mocapFnum,:,3);
pts3D = [x', y', z'];

pts2D = project3Dto2D(pts3D, vue2);

vue2video = VideoReader('Subject4-Session3-24form-Full-Take4-Vue2.mp4');
vue2video.CurrentTime = (mocapFnum-1)*(50/100)/vue2video.FrameRate;
vid2Frame = readFrame(vue2video);

figure;
image(vid2Frame);
axis on;
drawSkeleton(pts2D, 'r');
title(sprintf('Frame %d skeleton overlay', mocapFnum));