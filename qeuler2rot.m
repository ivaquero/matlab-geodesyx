% Rotation Matrix: Euler angles (phi, theta, psi) ==> rotation matrix
%
% Syntax:
%   rot = qeuler2rot(phi, theta, psi)
%
% Input:
%   phi, theta, psi             Roll/pitch/yaw in rad (scalar, or column/row vectors)
% Output:
%   rot                         Rotation matrix/matrices, 3 x 3 x N
%

function rot = qeuler2rot(phi, theta, psi)

    phi = phi(:).';                   % row (1, n) for third-dim layout
    theta = theta(:).';
    psi = psi(:).';

    cP = cos(phi); sP = sin(phi);
    cT = cos(theta); sT = sin(theta);
    cS = cos(psi); sS = sin(psi);

    rot = zeros(3, 3, numel(cT));
    rot(1, 1, :) = cS .* cT;
    rot(1, 2, :) = -sS .* cP + cS .* sT .* sP;
    rot(1, 3, :) = sS .* sP + cS .* sT .* cP;

    rot(2, 1, :) = sS .* cT;
    rot(2, 2, :) = cS .* cP + sS .* sT .* sP;
    rot(2, 3, :) = -cS .* sP + sS .* sT .* cP;

    rot(3, 1, :) = -sT;
    rot(3, 2, :) = cT .* sP;
    rot(3, 3, :) = cT .* cP;

end
