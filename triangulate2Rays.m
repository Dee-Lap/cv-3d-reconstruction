function pt3D = triangulate2Rays(c1, d1, c2, d2)
% use cross(d1, d2) to find the direction of the shortest segment connecting the two rays, then solve for where along
% each ray that segment starts/ends.

c1 = c1(:); c2 = c2(:);
d1 = d1(:); d2 = d2(:);

n = cross(d1, d2);          % perpendicular to both rays

% Solve for scalars s, t s.t. (c1 + s*d1) - (c2 + t*d2) is parallel to n
% project the baseline (c2-c1) onto vectors orthogonal to n
n1 = cross(d1, n);
n2 = cross(d2, n);

s = dot((c2 - c1), n2) / dot(d1, n2);   % how far along ray 1
t = dot((c1 - c2), n1) / dot(d2, n1);   % how far along ray 2

pt1 = c1 + s*d1;   % closest point on ray 1
pt2 = c2 + t*d2;   % closest point on ray 2

pt3D = ((pt1 + pt2) / 2)';   % midpoint of the shortest connecting segment
end