% Rotation Matrix ==> Euler angles (phi, theta, psi)
%
% from paper: "Adaptive Filter for a Miniature MEMS Based Attitude and
% Heading Reference System" by Wang et al, IEEE.
%
% Input:
%   rot                         Rotation matrix/matrices, 3 x 3 x N
% Output:
%   euler                       N x 3 matrix [phi theta psi] in radians
%

function euler = qrot2euler(rot)

    phi = atan2(rot(3, 2, :), rot(3, 3, :));

    r = rot(3, 1, :);
    theta = -atan(r ./ sqrt(max(0, 1 - r .^ 2)));   % guard |r|>1 numeric drift

    psi = atan2(rot(2, 1, :), rot(1, 1, :));

    euler = [phi(:), theta(:), psi(:)];

end
