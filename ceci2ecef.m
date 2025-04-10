% Coordinate Transformation: ECI ==> ECEF
%
% Syntax:
%   varargout = ceci2ecef(utc, x_eci, y_eci, z_eci)
%
% In:
%   utc                         UTC time in 'yyyy-mm-dd HH:MM:SS'
%   eci                         Target's inertial coordinates in [m, m, m]
% Out:
%   varargout                   Target's ECEF coordinates in [m, m, m]
% Attention:
%

function varargout = ceci2ecef(utc, x_eci, y_eci, z_eci)

    arguments
        utc datetime
        x_eci {mustBeReal, mustBeEqualSize(utc, x_eci)}
        y_eci {mustBeReal, mustBeEqualSize(utc, y_eci)}
        z_eci {mustBeReal, mustBeEqualSize(utc, z_eci)}
    end

    % Greenwich hour angles (radians)
    gst = siderealTime(juliandate(utc));

    ecef = rotate_z(gst, 'angleUnit', 'radians') * [x_eci, y_eci, z_eci].';

    if nargout == 1
        varargout{1} = ecef;
    elseif nargout == 3
        varargout{1} = ecef(1);
        varargout{2} = ecef(2);
        varargout{3} = ecef(3);
    else
        error('Invalid Number of Output Arguments');
    end

end
