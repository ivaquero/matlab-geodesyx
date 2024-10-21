% Coordinate Transformation: RFC ==> Antenna
%
% Syntax:
%   varargout = crfc2ant(front, az0, elev0, rslant0, options)
%
% Input:
%   front                           Target's front coordinates in [m, m, m]
%   [az0, elev0, rslant0]           Reference's antenna spherical coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's antenna spherical coordinates in [deg, deg, m]
% Attention:
%

function varargout = crfc2ant(front, az0, elev0, rslant0, options)

    arguments
        front (3, 1) double
        az0 {mustBeReal}
        elev0 {mustBeReal}
        rslant0 {mustBeReal, mustBeNonnegative}
        options.angleUnit (1, 1) string = 'degrees'
    end

    switch options.angleUnit
        case 'degrees'
            az0 = deg2rad(az0);
            elev0 = deg2rad(elev0);
        case 'radians'
        otherwise , error('Incorrect Input Angle Unit!');
    end

    M(1) = rslant0 * cos(elev0) * sin(az0);
    M(2) = rslant0 * cos(elev0) * cos(az0);
    M(3) = rslant0 * sin(elev0);
    M_c = front * M;

    % azimuth
    if abs(M_c(2)) < 1e-6

        if (M_c(1) < 0)
            azant = 3 * pi / 2;
        else
            azant = pi / 2;
        end

    elseif abs(M_c(2)) < 0

        if (abs(M_c(1)) > 1e-6)
            azant = atan(M_c(1) / M_c(2)) + pi;
        end

    else
        azant = atan(M_c(1) / M_c(2));
    end

    % azimuth of antenna
    azant = mod(azant, 2 * pi);
    % elevation of antenna
    elevant = asin(M_c(3) / rslant0);
    % slant range of antenna
    rslantant = rslant0;

    if nargout == 1
        varargout{1} = [azant, elevant, rslantant];
    elseif nargout == 3
        varargout{1} = azant;
        varargout{2} = elevant;
        varargout{3} = rslantant;
    else
        error('Invalid Number of Output Arguments');
    end

end
