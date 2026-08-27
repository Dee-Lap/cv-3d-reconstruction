load('Subject4-Session3-Take4_mocapJoints.mat');
load('vue2CalibInfo.mat');
load('vue4CalibInfo.mat');

mocapFnum = 17593;
x = mocapJoints(mocapFnum,:,1);
y = mocapJoints(mocapFnum,:,2);
z = mocapJoints(mocapFnum,:,3);
pts3D = [x', y', z'];

pts2D_vue2 = project3Dto2D(pts3D, vue2);
pts2D_vue4 = project3Dto2D(pts3D, vue4);

colors = lines(12);  % 12 distinct colors, one per joint

% get video frames for both views
vue2video = VideoReader('Subject4-Session3-24form-Full-Take4-Vue2.mp4');
vue2video.CurrentTime = (mocapFnum-1)*(50/100)/vue2video.FrameRate;
vid2Frame = readFrame(vue2video);

vue4video = VideoReader('Subject4-Session3-24form-Full-Take4-Vue4.mp4');
vue4video.CurrentTime = (mocapFnum-1)*(50/100)/vue4video.FrameRate;
vid4Frame = readFrame(vue4video);

figure;
subplot(1,2,1);
image(vid2Frame); hold on; axis on;
title('vue2: points');
for j = 1:12
    plot(pts2D_vue2(j,1), pts2D_vue2(j,2), 'o', 'Color', colors(j,:), 'MarkerFaceColor', colors(j,:));
end

subplot(1,2,2);
image(vid4Frame); hold on; axis on;
title('vue4: epipolar lines for vue2 points');
for j = 1:12
    drawEpipolarLine(pts2D_vue2(j,:), vue2, vue4, [1920 1088], colors(j,:));
    plot(pts2D_vue4(j,1), pts2D_vue4(j,2), 'o', 'Color', colors(j,:), 'MarkerFaceColor', colors(j,:));
end