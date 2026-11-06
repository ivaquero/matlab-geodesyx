% Quaternion ==> Euler angles (phi, theta, psi)
%
% from paper: "Adaptive Filter for a Miniature MEMS Based Attitude and
% Heading Reference System" by Wang et al, IEEE.
%
% Input:
%   quat                        Quaternion(s) [w x y z], 1 x 4 or N x 4
% Output:
%   euler                       N x 3 matrix [phi theta psi] in radians
%

function euler = qquat2euler(quat)

    q0 = quat(:, 1).'; q1 = quat(:, 2).'; q2 = quat(:, 3).'; q3 = quat(:, 4).';  % 1 x N

    rot = [];
    rot(1, 1, :) = 2 .* q0 .^ 2 - 1 + 2 .* q1 .^ 2;
    rot(2, 1, :) = 2 .* (q1 .* q2 - q0 .* q3);
    rot(3, 1, :) = 2 .* (q1 .* q3 + q0 .* q2);
    rot(3, 2, :) = 2 .* (q2 .* q3 - q0 .* q1);
    rot(3, 3, :) = 2 .* q0 .^ 2 - 1 + 2 .* q3 .^ 2;

    phi = atan2(rot(3, 2, :), rot(3, 3, :));

    r = rot(3, 1, :);
    theta = -atan(r ./ sqrt(max(0, 1 - r .^ 2)));   % guard |r|>1 numeric drift

    psi = atan2(rot(2, 1, :), rot(1, 1, :));

    euler = [phi(:), theta(:), psi(:)];

end
