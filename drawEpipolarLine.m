function drawEpipolarLine(pt2D, camA, camB, imgSize, color)
if nargin < 5
    color = 'g';
end

[camCenter, rayDir] = pixel2DtoRay(pt2D, camA);

% use two well-separated distances along the ray to define the line's direction
t1 = 1000;
t2 = 10000;   % pushed further out to safely bracket typical scene depths
p1_3D = camCenter + t1 * rayDir;
p2_3D = camCenter + t2 * rayDir;

pts2D_B = project3Dto2D([p1_3D; p2_3D], camB);
x1 = pts2D_B(1,1); y1 = pts2D_B(1,2);
x2 = pts2D_B(2,1); y2 = pts2D_B(2,2);

hold on;

% extend the line across the full image width (or height, if near-vertical)
if abs(x2 - x1) > abs(y2 - y1)
    % mostly horizontal-ish line: solve for y at x=0 and x=imgSize(1)
    slope = (y2 - y1) / (x2 - x1);
    xEdges = [0, imgSize(1)];
    yEdges = y1 + slope * (xEdges - x1);
else
    % mostly vertical-ish line: solve for x at y=0 and y=imgSize(2)
    slope = (x2 - x1) / (y2 - y1);
    yEdges = [0, imgSize(2)];
    xEdges = x1 + slope * (yEdges - y1);
end

plot(xEdges, yEdges, '-', 'Color', color, 'LineWidth', 1.5);
xlim([0 imgSize(1)]);
ylim([0 imgSize(2)]);
end