% Quaternion: axis-angle ==> quaternion (Hamilton w,x,y,z)
%
% Syntax:
%   quat = qangle2quat(axis, angle)
%
% Input:
%   axis                        Rotation axis/axes, one 1x3 row or N x 3
%   angle                       Rotation angle in rad (scalar, or N x 1 / 1 x N)
% Output:
%   quat                        Quaternion(s) [w x y z], 1 x 4 or N x 4
%

function quat = qangle2quat(axis, angle)

    axis = axis(:).';                 % normalize to (3, nAxis) columns
    n = size(axis, 2);

    angle = angle(:);                 % column
    if numel(angle) == 1 && n > 1
        angle = repmat(angle, n, 1);
    end
    s = sin(angle / 2);
    c = cos(angle / 2);

    quat0 = c;
    quat1 = -axis(1, :).' .* s;
    quat2 = -axis(2, :).' .* s;
    quat3 = -axis(3, :).' .* s;
    quat = [quat0 quat1 quat2 quat3];

end
