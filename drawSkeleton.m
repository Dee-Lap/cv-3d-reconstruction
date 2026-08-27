function drawSkeleton(pts, color)
% drawSkeleton - draws line segments connecting body joints to form a skeleton
%
% Inputs:
%   pts   - 12x2 (2D pixel coords) or 12x3 (3D world coords), one row per joint,
%           in the standard order: RS,RE,RW,LS,LE,LW,RH,RK,RA,LH,LK,LA
%   color - line color, e.g. 'r' or [0.8 0.2 0.2]

if nargin < 2
    color = 'b';
end

is3D = size(pts,2) == 3;

% joint index pairs to connect (limbs + torso)
limbs = [1 2; 2 3; ...   % right arm: shoulder-elbow-wrist
    4 5; 5 6; ...   % left arm
    7 8; 8 9; ...   % right leg: hip-knee-ankle
    10 11; 11 12;...% left leg
    1 4; ...        % shoulder to shoulder
    7 10];          % hip to hip

hold on;
for k = 1:size(limbs,1)
    a = limbs(k,1); b = limbs(k,2);
    if is3D
        plot3(pts([a b],1), pts([a b],2), pts([a b],3), '-', 'Color', color, 'LineWidth', 2);
    else
        plot(pts([a b],1), pts([a b],2), '-', 'Color', color, 'LineWidth', 2);
    end
end

% spine: midpoint of shoulders to midpoint of hips
midShoulder = (pts(1,:) + pts(4,:)) / 2;
midHip = (pts(7,:) + pts(10,:)) / 2;
spinePts = [midShoulder; midHip];

if is3D
    plot3(spinePts(:,1), spinePts(:,2), spinePts(:,3), '-', 'Color', color, 'LineWidth', 2);
    plot3(pts(:,1), pts(:,2), pts(:,3), 'o', 'Color', color, 'MarkerFaceColor', color);
else
    plot(spinePts(:,1), spinePts(:,2), '-', 'Color', color, 'LineWidth', 2);
    plot(pts(:,1), pts(:,2), 'o', 'Color', color, 'MarkerFaceColor', color);
end
end