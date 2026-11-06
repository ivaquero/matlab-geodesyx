% Coordinate Transformation: Platform ==> Antenna
%
% Syntax:
%   varargout = cplatform2ant(platform, az0, elev0, rslant0, options)
%
% Input:
%   platform                        Target's position in the platform (ENU) frame
%                                   as a 3x1 Cartesian vector in [m, m, m]
%   [az0, elev0, rslant0]           Antenna boresight (reference LOS) spherical
%                                   coordinates in [deg, deg, m] (see Attention)
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut            Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's antenna/ENU spherical coordinates in
%                                   [angle, angle, m]
% Attention:
%   RECONSTRUCTED. Companion of `cant2platform`: the platform frame is the ENU
%   reference frame, so the antenna/ENU spherical coordinates are the target's ENU
%   spherical coordinates:
%       [azant, elevant, rslantant] = cenu2aer(platform)
%   The reference LOS (az0, elev0, rslant0) does not enter the result. The
%   original stub's `platform * M` was a 3x1-by-1x3 outer product (a 3x3 matrix).
%
% References:
%

function varargout = cplatform2ant(platform, az0, elev0, rslant0, options)

    arguments
        platform (3, 1) double
        az0 {mustBeReal} %#ok
        elev0 {mustBeReal} %#ok
        rslant0 {mustBeReal, mustBeNonnegative} %#ok
        options.angleUnit (1, 1) string = 'degrees'
        options.angleUnitOut (1, 1) string = 'degrees'
    end

    [azant, elevant, rslantant] = cenu2aer(platform(1), platform(2), platform(3), 'angleUnitOut', options.angleUnitOut);

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
