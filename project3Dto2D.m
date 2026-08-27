function pts2D = project3Dto2D(pts3D, camStruct)
% pull P and K out as their own variables,
% process one point at a time using homogeneous coordinates.

P = camStruct.Pmat;   % 3x4 projection matrix
K = camStruct.Kmat;   % 3x3 intrinsics matrix

N = size(pts3D, 1);
pts2D = zeros(N, 2);

for i = 1:N
    point = [pts3D(i,:)'; 1];      % 4x1 homogeneous 3D point

    camCoord = P * point;           % 3x1, camera coordinates
    normImg  = camCoord(1:2) / camCoord(3);   % normalized image coords

    pixelHom = K * [normImg; 1];    % apply intrinsics, get pixel coords
    pts2D(i,:) = pixelHom(1:2)';
end
end