function demo()
% runs the full 3D to 2D to 3D reconstruction pipeline with no
% arguments, loading data from the current directory and displaying
% intermediate and final results.

%% Load data
load('Subject4-Session3-Take4_mocapJoints.mat');
load('vue2CalibInfo.mat');
load('vue4CalibInfo.mat');

%% Step 3+4+5 demo on one example frame (max error frame)
mocapFnum = 17593;
x = mocapJoints(mocapFnum,:,1);
y = mocapJoints(mocapFnum,:,2);
z = mocapJoints(mocapFnum,:,3);
pts3D = [x', y', z'];

pts2D_vue2 = project3Dto2D(pts3D, vue2);
pts2D_vue4 = project3Dto2D(pts3D, vue4);

% show 2D projection overlaid on video frame (vue2)
vue2video = VideoReader('Subject4-Session3-24form-Full-Take4-Vue2.mp4');
vue2video.CurrentTime = (mocapFnum-1)*(50/100)/vue2video.FrameRate;
vid2Frame = readFrame(vue2video);

figure('Name','Step 3: 2D projection (vue2)');
image(vid2Frame); axis on; hold on;
drawSkeleton(pts2D_vue2, 'r');
title(sprintf('Frame %d: projected skeleton on vue2', mocapFnum));

vue4video = VideoReader('Subject4-Session3-24form-Full-Take4-Vue4.mp4');
vue4video.CurrentTime = (mocapFnum-1)*(50/100)/vue4video.FrameRate;
vid4Frame = readFrame(vue4video);
figure('Name','Step 3: 2D projection (vue4)');
image(vid4Frame); axis on; hold on;
drawSkeleton(pts2D_vue4, 'r');
title(sprintf('Frame %d: projected skeleton on vue4', mocapFnum));

% triangulate back to 3D
[c1, d1] = pixel2DtoRay(pts2D_vue2, vue2);
[c2, d2] = pixel2DtoRay(pts2D_vue4, vue4);
reconstructed = zeros(12,3);
for j = 1:12
    reconstructed(j,:) = triangulate2Rays(c1, d1(j,:), c2, d2(j,:));
end

figure('Name','Step 5: original vs reconstructed 3D skeleton');
drawSkeleton(pts3D, 'b'); hold on;
drawSkeleton(reconstructed, 'r');
legend('Original','Reconstructed');
title(sprintf('Frame %d: original (blue) vs reconstructed (red)', mocapFnum));
axis equal;

%% Full-dataset error analysis
fprintf('Running full-dataset error analysis ...\n');
[statsTable, perFrameError, validFrameNums, L2all] = computeL2error(mocapJoints, vue2, vue4);

disp('Per-joint and overall L2 error stats [mean, std, min, median, max]:');
disp(statsTable);

figure('Name','Total error across sequence');
plot(validFrameNums, perFrameError);
xlabel('Mocap frame number'); ylabel('Total L2 error (12 joints)');
title('Reconstruction error across full sequence');

[minErr, minIdx] = min(perFrameError);
[maxErr, maxIdx] = max(perFrameError);
fprintf('Min error: %.6e at frame %d\n', minErr, validFrameNums(minIdx));
fprintf('Max error: %.6e at frame %d\n', maxErr, validFrameNums(maxIdx));

fprintf('Demo complete.\n');
end