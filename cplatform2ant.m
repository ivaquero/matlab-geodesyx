% Coordinate Transformation: Platorm ==> Antenna
%
% Syntax:
%   varargout = cplatform2ant(platform, az0, elev0, rslant0, options)
%
% Input:
%   platform                        Target's platform spherical coordinates in [deg, deg, m]
%   [az0, elev0, rslant0]           Reference's antenna spherical coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut            Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's antenna coordinates in [m, m, m]
% Attention:
%

function varargout = cplatform2ant(platform, az0, elev0, rslant0, options)

    arguments
        platform (3, 1) double
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
    Mc = platform * M;

    % azimuth, elevation, slant range
    if (Mc(2) > 1e-6)
        azant = atan(Mc(1) / Mc(2));
        elevant = asin(Mc(3) / rslant0);
        rslantant = rslant0;
    else
        azant = 0;
        elevant = 0;
        rslantant = 0;
    end

    switch options.angleUnitOut
        case 'degrees'
        case 'radians'
            azant = deg2rad(azant);
            elevant = deg2rad(elevant);
        otherwise , error('Incorrect Output Angle Unit!');
    end

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
