% Coordinate Transformation: Antenna ==> Platform
%
% Syntax:
%   varargout = cant2platform(antenna, az0, elev0, rslant0, options)
%
% Input:
%   antenna                         Target's position in the antenna/ground (ENU)
%                                   frame as [East; North; Up] in [m, m, m]
%   [az0, elev0, rslant0]           Antenna boresight (reference LOS) spherical
%                                   coordinates in [deg, deg, m] (see Attention)
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut            Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's platform spherical coordinates in
%                                   [angle, angle, m]
% Attention:
%   RECONSTRUCTED. The schema (docs/geodesyx.drawio.png) and the toolbox define
%   only one antenna-frame rotation, `renu2rfc` (ENU -> RFC boresight). No
%   separate platform-frame rotation is provided, so the platform frame is taken
%   to be the ENU reference frame itself and the platform spherical coordinates are
%   the target's ENU spherical coordinates:
%       [azp, elevp, rslantp] = cenu2aer(antenna)
%   Consequently the reference LOS (az0, elev0, rslant0) does not affect the
%   platform-frame result; it is accepted for API symmetry with `cant2rfc`. If a
%   distinct platform attitude is later defined, replace the identity here with
%   that rotation. Exact inverse of `cplatform2ant`.
%
% References:
%

function varargout = cant2platform(antenna, az0, elev0, rslant0, options)

    arguments
        antenna (3, 1) double
        az0 {mustBeReal} %#ok
        elev0 {mustBeReal} %#ok
        rslant0 {mustBeReal, mustBeNonnegative} %#ok
        options.angleUnit (1, 1) string = 'degrees'
        options.angleUnitOut (1, 1) string = 'degrees'
    end

    [azp, elevp, rslantp] = cenu2aer(antenna(1), antenna(2), antenna(3), 'angleUnitOut', options.angleUnitOut);

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
