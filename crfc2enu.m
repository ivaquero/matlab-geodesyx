% Coordinate Transformation: RFC ==> ENU
%
% Syntax:
%   varargout = crfc2enu(rfc, az0, elev0, options)
%
% Input:
%   rfc                         Target's front coordinates in [m, m, m]
%   [azant, elevant]            Antenna's normal spherical coordinates in [deg, deg]
%   options.angleUnit           Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                   Target's ENU coordinates in [m, m, m]
% Attention:
%
% References:
%

function varargout = crfc2enu(rfc, az0, elev0, options)

    arguments
        rfc (3, 1) double
        az0 {mustBeReal}
        elev0 {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    cenu2rfc = renu2rfc(az0, elev0, 'angleUnit', options.angleUnit);

    enu = cenu2rfc' * rfc;

    if nargout == 1
        varargout{1} = enu;
    elseif nargout == 3
        varargout{1} = enu(1);
        varargout{2} = enu(2);
        varargout{3} = enu(3);
    else
        error('Invalid Number of Output Arguments');
    end

end
