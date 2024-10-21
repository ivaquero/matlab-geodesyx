% Coordinate Transformation: ECEF ==> ECI
%
% Syntax:
%   varargout = cecef2eci(utc, x, y, z)
% Input:
%   utc                         UTC time in 'yyyy-mm-dd HH:MM:SS'
%   [x, y, z]                   Target's ECEF coordinates in [m, m, m]
%   options.angleUnit           Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                   Target's inertial coordinates in [m, m, m]
% Attention:
%   Didn't consider the planetary rotation, the error is usually > 1%; for higher accuracy, please use the official function 'ecef2eci()' in aerospace toolbox.

function varargout = cecef2eci(utc, x, y, z)

    arguments
        utc datetime
        x {mustBeReal, mustBeEqualSize(utc, x)}
        y {mustBeReal, mustBeEqualSize(utc, y)}
        z {mustBeReal, mustBeEqualSize(utc, z)}
    end

    % Greenwich hour angles (radians)
    gst = siderealTime(juliandate(utc));

    % Convert into ECI
    eci = rotate_z(gst, 'angleUnit', 'radians').' * [x, y, z].';

    if nargout == 1
        varargout{1} = eci;
    elseif nargout == 3
        varargout{1} = eci(1);
        varargout{2} = eci(2);
        varargout{3} = eci(3);
    else
        error('Invalid Number of Output Arguments');
    end

end
