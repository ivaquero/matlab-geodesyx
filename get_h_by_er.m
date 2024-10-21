% Calculation: Elevation, Slant Range, Station Height ==> Altitude
%
% Syntax:
%   Height = get_h_by_er(elev, rslant, alt0)
%
% Input:
%   elev                    Target's elevant in deg
%   rslant                  Target's slant range in m
%   alt0  	                Reference's altitude in meters
% Output:
%   Height                  Target's altitude in meters
% Attention:
%

function Height = get_h_by_er(elev, rslant, alt0, options)

    arguments
        elev {mustBeReal}
        rslant {mustBeReal}
        alt0 {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    Rmean = options.spheroid.MeanRadius;
    % equivalent Earth radius (m)
    Rt = Rmean * 4/3;

    switch options.angleUnit
        case 'degrees'
            elev = deg2rad(elev);
        case 'radians'
        otherwise , error('Incorrect Input Angle Unit!');
    end

    Height = (rslant .* sin(elev)) + (rslant .* rslant ./ (2 * Rt)) + alt0;
end
