% Coordinate Transformation: Antenna ==> RFC
%
% Syntax:
%   varargout = cant2rfc(antenna, az0, ele0, rslant0, options)
% Input:
%   antenna                         Target's antenna coordinates in [m, m, m]
%   [az0, ele0, rslant0]            Reference's antenna spherical coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's front spherical coordinates in [deg, deg, m]
% Attention:
%

function varargout = cant2rfc(antenna, az0, ele0, rslant0, options)

    arguments
        antenna (3, 1) double
        az0 {mustBeReal}
        ele0 {mustBeReal}
        rslant0 {mustBeReal, mustBeNonnegative}
        options.angleUnit (1, 1) string = 'degrees'
    end

    switch options.angleUnit
        case 'degrees'
            az0 = deg2rad(az0);
            ele0 = deg2rad(ele0);
        case 'radians'
        otherwise , error('Incorrect Input Angle Unit!');
    end

    M(1) = rslant0 * cos(ele0) * sin(az0);
    M(2) = rslant0 * cos(ele0) * cos(az0);
    M(3) = rslant0 * sin(ele0);
    M_c = antenna' * M;

    % azimuth
    if abs(M_c(2)) < 1e-6

        if (M_c(1) < 0)
            azf = 3 * pi / 2;
        else
            azf = pi / 2;
        end

    elseif abs(M_c(2)) < 0

        if (abs(M_c(1)) > 1e-6)
            azf = atan(M_c(1) / M_c(2)) + pi;
        end

    else
        azf = atan(M_c(1) / M_c(2));
    end

    % azimuth of front
    azf = mod(azf, 2 * pi);
    % elevation of front
    elevf = asin(M_c(3) / rslant0);
    % slant range of front
    rslantf = rslant0;

    if nargout == 1
        varargout{1} = [azf, elevf, rslantf];
    elseif nargout == 3
        varargout{1} = azf;
        varargout{2} = elevf;
        varargout{3} = rslantf;
    else
        error('Invalid Number of Output Arguments');
    end

end
