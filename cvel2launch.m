% Coordinate Transformation: Velocity ==> Launch
%
% Syntax:
%   varargout = cvel2launch(velocity, body_vel, lat0, lon0, alt0, options)
%
% Input:
%   velocity                      Target's velocity-frame coordinates in [m, m, m]
%   body_vel                      Target's velocity in the launch/ground frame in
%                                 [m/s, m/s, m/s] as [East; North; Up]
%   [lat0, lon0, alt0]            Reference's geodetic coordinates in [deg, deg, m]
%   options.spheroid              Reference ellipsoid (default wgs84)
%   options.angleUnit             Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                     Target's launch (ground/ENU) coordinates in [m, m, m]
% Attention:
%   RECONSTRUCTED. Exact inverse of `claunch2vel`:
%       launch = launch2vel' * velocity - ECEF_g
%   with launch2vel = rlaunch2vel(unedv2euler(body_vel)). For the pair to be a
%   true inverse, `body_vel` must be the same launch-frame velocity vector that
%   was passed to `claunch2vel` as `launch_vel`.
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

    [roll, pitch, yaw] = unedv2euler(body_vel, 'angleUnit', options.angleUnit);

    launch2vel = rlaunch2vel(roll, pitch, yaw, 'angleUnit', options.angleUnit);
    [ex, ey, ez] = cgeodetic2ecef(lat0, lon0, alt0, 'angleUnit', options.angleUnit, 'spheroid', options.spheroid);
    ECEF_g = [ex; ey; ez];
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
