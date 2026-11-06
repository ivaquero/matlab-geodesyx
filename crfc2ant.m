% Coordinate Transformation: RFC ==> Antenna
%
% Syntax:
%   varargout = crfc2ant(front, az0, elev0, rslant0, options)
%
% Input:
%   front                           Target's position in the RFC (boresight) frame
%                                   as a 3x1 Cartesian vector in [m, m, m]
%   [az0, elev0, rslant0]           Antenna boresight (reference LOS) spherical
%                                   coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut            Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's antenna/ENU spherical coordinates in
%                                   [angle, angle, m]
% Attention:
%   RECONSTRUCTED. Exact inverse of `cant2rfc`:
%       enu = renu2rfc(az0, elev0)' * front
%       [azant, elevant, rslantant] = cenu2aer(enu)
%   `rslant0` is accepted for API compatibility but does not enter the rotation.
%   The original stub's `front * M` was a 3x1-by-1x3 outer product (a 3x3 matrix),
%   not a projection, and could return complex values.
%
% References:
%

function varargout = crfc2ant(front, az0, elev0, rslant0, options)

    arguments
        front (3, 1) double
        az0 {mustBeReal}
        elev0 {mustBeReal}
        rslant0 {mustBeReal, mustBeNonnegative} %#ok
        options.angleUnit (1, 1) string = 'degrees'
        options.angleUnitOut (1, 1) string = 'degrees'
    end

    enu = renu2rfc(az0, elev0, 'angleUnit', options.angleUnit)' * front;
    [azant, elevant, rslantant] = cenu2aer(enu(1), enu(2), enu(3), 'angleUnitOut', options.angleUnitOut);

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
