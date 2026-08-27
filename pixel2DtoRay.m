function [camCenter, rayDir] = pixel2DtoRay(pts2D, camStruct)
% pull P (rotation) and K out as bare variables,
% compute vec = P * inv(K) * point for each pixel

K = camStruct.Kmat;            % 3x3 intrinsics
P = camStruct.Pmat(:, 1:3);    % 3x3 rotation part

N = size(pts2D, 1);
rayDir = zeros(N, 3);

for i = 1:N
    point = [pts2D(i,:)'; 1];       % 3x1 homogeneous pixel coord

    vec = P' * (K \ point);          % same as P*inv(K)*point in the hints
    % transposed since we're going camera->world,

    rayDir(i,:) = (vec / norm(vec))';   % unit direction
end

camCenter = camStruct.position;   % 1x3, camera center is the same for every ray
end