% Coordinate Transformation: Antenna ==> Platorm
%
% Syntax:
%   varargout = cant2platfrom(antenna, az0, elev0, rslant0, options)
%
% Input:
%   antenna                         Target's antenna coordinates in [m, m, m]
%   [az0, elev0, rslant0]           Reference's antenna spherical coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut            Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's platform spherical coordinates in [deg, deg, m]
% Attention:
%

function varargout = cant2platfrom(antenna, az0, elev0, rslant0, options)

    arguments
        antenna (3, 1) double
        az0 {mustBeReal}
        elev0 {mustBeReal}
        rslant0 {mustBeReal, mustBeNonnegative}
        options.angleUnit (1, 1) string = 'degrees'
        options.angleUnitOut (1, 1) string = 'degrees'
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
    M_c = antenna' * M;

    azp = atan2(M_c(1), M_c(2));
    elevp = asin(M_c(3) / rslant0);
    rslantp = rslant0;

    switch options.angleUnitOut
        case 'degrees'
        case 'radians'
            azp = deg2rad(azp);
            elevp = deg2rad(elevp);
        otherwise , error('Incorrect Output Angle Unit!');
    end

    if nargout == 1
        varargout{1} = [azp, elevp, rslantp];
    elseif nargout == 3
        varargout{1} = azp;
        varargout{2} = elevp;
        varargout{3} = rslantp;
    else
        error('Invalid Number of Output Arguments');
    end

end
