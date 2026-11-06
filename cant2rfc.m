% Coordinate Transformation: Antenna ==> RFC
%
% Syntax:
%   varargout = cant2rfc(antenna, az0, ele0, rslant0, options)
%
% Input:
%   antenna                         Target's position in the antenna/ground (ENU)
%                                   frame as [East; North; Up] in [m, m, m]
%   [az0, ele0, rslant0]            Antenna boresight (reference LOS) spherical
%                                   coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut            Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's front (RFC / boresight-frame) spherical
%                                   coordinates in [angle, angle, m]
% Attention:
%   RECONSTRUCTED. The reference LOS (az0, ele0) defines the RFC frame via
%   `renu2rfc` (its third axis is the boresight). The target is rotated into that
%   frame and its spherical coordinates are extracted with the geodesy azimuth /
%   elevation convention (`cenu2aer`):
%       rfc = renu2rfc(az0, ele0) * antenna
%       [azf, elevf, rslantf] = cenu2aer(rfc)
%   `rslant0` is accepted for API compatibility; the boresight direction depends
%   only on (az0, ele0), so it does not enter the rotation. Exact inverse of
%   `crfc2ant`. The original stub's `antenna' * M` was a broken 1x3-by-1x3 product.
%
% References:
%

function varargout = cant2rfc(antenna, az0, ele0, rslant0, options)

    arguments
        antenna (3, 1) double
        az0 {mustBeReal}
        ele0 {mustBeReal}
        rslant0 {mustBeReal, mustBeNonnegative} %#ok
        options.angleUnit (1, 1) string = 'degrees'
        options.angleUnitOut (1, 1) string = 'degrees'
    end

    rfc = renu2rfc(az0, ele0, 'angleUnit', options.angleUnit) * antenna;
    [azf, elevf, rslantf] = cenu2aer(rfc(1), rfc(2), rfc(3), 'angleUnitOut', options.angleUnitOut);

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
