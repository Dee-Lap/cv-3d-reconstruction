function [statsTable, perFrameError, validFrameNums, L2all] = computeL2error(mocapJoints, vue2, vue4)
% computeL2error - projects, triangulates, and measures 3D reconstruction error
%
% Inputs:
%   mocapJoints - Fx12x4 array (frame x joint x [X,Y,Z,conf])
%   vue2, vue4  - camera calibration structs
%
% Outputs:
%   statsTable    - 13x5 matrix: rows = 12 joints + 1 overall,
%                   cols = [mean, std, min, median, max] of L2 error
%   perFrameError - Vx1, sum of L2 error across 12 joints, per valid frame
%   validFrameNums- Vx1, the original frame numbers that were used
%   L2all         - VxJ matrix of L2 error per valid frame per joint (for
%                   further inspection, e.g. finding worst joint per frame)

% only frames where all 12 joints have confidence 1
conf = mocapJoints(:,:,4);
validMask = all(conf == 1, 2);
validFrameNums = find(validMask);
V = numel(validFrameNums);

L2all = zeros(V, 12);

for i = 1:V
    f = validFrameNums(i);

    x = mocapJoints(f,:,1);
    y = mocapJoints(f,:,2);
    z = mocapJoints(f,:,3);
    pts3D = [x', y', z'];   % 12x3

    pts2D_vue2 = project3Dto2D(pts3D, vue2);
    pts2D_vue4 = project3Dto2D(pts3D, vue4);

    [c1, d1] = pixel2DtoRay(pts2D_vue2, vue2);
    [c2, d2] = pixel2DtoRay(pts2D_vue4, vue4);

    reconstructed = zeros(12,3);
    for j = 1:12
        reconstructed(j,:) = triangulate2Rays(c1, d1(j,:), c2, d2(j,:));
    end

    L2all(i,:) = sqrt(sum((pts3D - reconstructed).^2, 2))';
end

perFrameError = sum(L2all, 2);   % total error per frame, for the plot

% per-joint stats (12 rows)
jointStats = [mean(L2all,1)', std(L2all,0,1)', min(L2all,[],1)', ...
    median(L2all,1)', max(L2all,[],1)'];

% overall stats, all joints/frames pooled together (1 row)
allErrors = L2all(:);
overallStats = [mean(allErrors), std(allErrors), min(allErrors), ...
    median(allErrors), max(allErrors)];

statsTable = [jointStats; overallStats];   % 13x5
end