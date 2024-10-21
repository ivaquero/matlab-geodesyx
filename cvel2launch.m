% Coordinate Transformation: Body ==> ENU
%
% Syntax:
%   varargout = cvel2launch(velocity, body_vel, lat0, lon0, alt0, options)
%
% Input:
%   velocity                    Target's body coordinates in [m, m, m]
%   body_vel                    Target's velocity in [m/s, m/s, m/s]
%   [lat0, lon0, alt0]          Reference's geodetic coordinates in [deg, deg, m]
%   options.spheroid            Reference ellipsoid model: 'wgs84' (default) or 'grs80'
%   options.angleUnit           Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                   Target's ENU coordinates in [m, m, m]
% Attention:
%
% References:
%

function varargout = cvel2launch(velocity, body_vel, lat0, lon0, alt0, options)

    arguments
        velocity (3, 1) double
        body_vel (3, 1) double
        lat0 {mustBeReal}
        lon0 {mustBeReal}
        alt0 {mustBeReal}
        options.spheroid (1, 1) refEllipsoid = refEllipsoid('wgs84', 'm')
        options.angleUnit (1, 1) string = 'degrees'
    end

    [roll, pitch, yaw] = unedv2euler(body_vel, dt);

    launch2vel = rlaunch2vel(roll, pitch, yaw, 'angleUnit', options.angleUnit);
    ECEF_g = cgeodetic2ecef(lat0, lon0, alt0, 'angleUnit', options.angleUnit, 'spheroid', options.spheroid);
    launch = launch2vel' * velocity - ECEF_g;

    if nargout == 1
        varargout{1} = launch;
    elseif nargout == 3
        varargout{1} = launch(1);
        varargout{2} = launch(2);
        varargout{3} = launch(3);
    else
        error('Invalid Number of Output Arguments');
    end

end
