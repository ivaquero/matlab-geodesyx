% Rotation Matrix: axis-angle ==> rotation matrix (active Rodrigues form)
%
% Syntax:
%   rot = qangle2rot(axis, angle)
%
% Input:
%   axis                        Rotation axis/axes, one 1x3 row or N x 3
%   angle                       Rotation angle in rad (scalar, or N x 1 / 1 x N)
% Output:
%   rot                         Rotation matrix/matrices, 3 x 3 x N
%

function rot = qangle2rot(axis, angle)

    [n, ~] = size(axis);              % axis has 3 columns

    angle = angle(:).';               % row (1, n) for third-dim layout
    if numel(angle) == 1 && n > 1
        angle = repmat(angle, 1, n);
    end

    kx = axis(:, 1).';                 % (1, n)
    ky = axis(:, 2).';
    kz = axis(:, 3).';
    cT = cos(angle);
    sT = sin(angle);
    vT = 1 - cT;

    rot = zeros(3, 3, n);
    rot(1, 1, :) = kx .* kx .* vT + cT;
    rot(1, 2, :) = kx .* ky .* vT - kz .* sT;
    rot(1, 3, :) = kx .* kz .* vT + ky .* sT;

    rot(2, 1, :) = kx .* ky .* vT + kz .* sT;
    rot(2, 2, :) = ky .* ky .* vT + cT;
    rot(2, 3, :) = ky .* kz .* vT - kx .* sT;

    rot(3, 1, :) = kx .* kz .* vT - ky .* sT;
    rot(3, 2, :) = ky .* kz .* vT + kx .* sT;
    rot(3, 3, :) = kz .* kz .* vT + cT;

end
