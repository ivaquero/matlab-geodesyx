% Coordinate Transformation: ENU ==> RFC
%
% Syntax:
%   varargout = cenu2rfc(enu, az0, elev0, options)
%
% Input:
%   enu                         Target's ENU coordinates in [m, m, m]
%   [az0, elev0]                Antenna's normal spherical coordinates in [deg, deg]
%   options.angleUnit           Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                   Target's front spherical coordinates in [deg, deg, m]
% Attention:
%
% References:
%

function varargout = cenu2rfc(enu, az0, elev0, options)

    arguments
        enu (3, 1) double
        az0 {mustBeReal}
        elev0 {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    cenu2rfc = renu2rfc(az0, elev0, 'angleUnit', options.angleUnit);

    rfc = cenu2rfc * enu;

    if nargout == 1
        varargout{1} = rfc;
    elseif nargout == 3
        varargout{1} = rfc(1);
        varargout{2} = rfc(2);
        varargout{3} = rfc(3);
    else
        error('Invalid Number of Output Arguments');
    end

end
