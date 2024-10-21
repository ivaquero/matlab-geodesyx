% Calculation: Altitude, East, North, Station Height ==> Slant Range
%
% Syntax:
%   rslant = get_rslant_by_enh(alt, xEast, yNorth, alt0)
%
% Input:
%   alt                 Target's altitude in meters
%   [xEast, yNorth]     Target's ENU coordinates: east, north in [m, m, m]
%   alt0  	            Reference's altitude in meters
% Output:
%   rslant              Target's slant range in meters
% Attention:
%

function rslant = get_rslant_by_enh(alt, xEast, yNorth, alt0)

    arguments
        alt {mustBeReal}
        xEast {mustBeReal}
        yNorth {mustBeReal}
        alt0 {mustBeReal}
    end

    Rmean = options.spheroid.MeanRadius;
    % equivalent Earth radius (m)
    Rt = Rmean * 4/3;

    [~, rslant0] = cen2ar(xEast, yNorth);

    dalt = (alt - alt0);

    rslant = sqrt(2 * Rt ^ 2 + 2 * dalt * Rt - 2 * sqrt(Rt ^ 4 + 2 * Rt ^ 3 * dalt - rslant0 .^ 2 * Rt ^ 2));
end
