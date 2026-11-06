% Quaternion ==> Rotation Matrix (Hamilton w,x,y,z)
%
% Syntax:
%   rot = qquat2rot(quat)
%
% Input:
%   quat                        Quaternion(s) [w x y z], 1 x 4 or N x 4
% Output:
%   rot                         Rotation matrix/matrices, 3 x 3 x N
%

function rot = qquat2rot(quat)

    [rows, ~] = size(quat);
    q0 = quat(:, 1).'; q1 = quat(:, 2).'; q2 = quat(:, 3).'; q3 = quat(:, 4).';  % 1 x N

    rot = zeros(3, 3, rows);
    rot(1, 1, :) = 2 .* q0 .^ 2 - 1 + 2 .* q1 .^ 2;
    rot(1, 2, :) = 2 .* (q1 .* q2 + q0 .* q3);
    rot(1, 3, :) = 2 .* (q1 .* q3 - q0 .* q2);
    rot(2, 1, :) = 2 .* (q1 .* q2 - q0 .* q3);
    rot(2, 2, :) = 2 .* q0 .^ 2 - 1 + 2 .* q2 .^ 2;
    rot(2, 3, :) = 2 .* (q2 .* q3 + q0 .* q1);
    rot(3, 1, :) = 2 .* (q1 .* q3 + q0 .* q2);
    rot(3, 2, :) = 2 .* (q2 .* q3 - q0 .* q1);
    rot(3, 3, :) = 2 .* q0 .^ 2 - 1 + 2 .* q3 .^ 2;

end
