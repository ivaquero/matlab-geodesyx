% Rotation Matrix: ENU ==> RFC
%
% Syntax:
%   enu2rfc = renu2rfc(az0, elev0, options)
%
% Input:
%   [az0, elev0]                Antenna's normal spherical coordinates in [deg, deg]
%   options.angleUnit           Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   renu2rfc                    Rotation matrix
% Attention:
%
% References:
%

function enu2rfc = renu2rfc(az0, elev0, options)

    arguments
        az0 {mustBeReal}
        elev0 {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    switch options.angleUnit
        case 'degrees'
            az0 = deg2rad(az0);
            elev0 = deg2rad(elev0);
        case 'radians'
        otherwise , error('Incorrect Input Angle Unit!');
    end

    enu2rfc = [ ...
                   -cos(az0), sin(az0), 0; ...
                   -sin(az0) * sin(elev0), -cos(az0) * sin(elev0), cos(elev0); ...
                   sin(az0) * cos(elev0), cos(az0) * cos(elev0), sin(elev0)
               ];
end
