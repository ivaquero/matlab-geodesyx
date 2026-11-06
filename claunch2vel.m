% Coordinate Transformation: Launch ==> Velocity
%
% Syntax:
%   varargout = claunch2vel(launch, launch_vel, lift, side_force, lat0, lon0, alt0, options)
%
% Input:
%   launch                          Target's launch (ground/ENU) coordinates in [m, m, m]
%   launch_vel                      Target's velocity in the launch frame in
%                                   [m/s, m/s, m/s] as [East; North; Up]
%   lift                            Aerodynamic lift vector (reserved, see Attention)
%   side_force                      Aerodynamic side-force vector (reserved, see Attention)
%   [lat0, lon0, alt0]              Reference's geodetic coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
%   options.spheroid                Reference ellipsoid (default wgs84)
% Output:
%   varargout                       Target's velocity-frame coordinates in [m, m, m]
% Attention:
%   RECONSTRUCTED. The launch->velocity attitude is taken from the velocity
%   vector via `unedv2euler` (heading + flight-path angle, zero bank) and the
%   rotation `rlaunch2vel`. This is the exact inverse of `cvel2launch`:
%       velocity = launch2vel * (launch + ECEF_g)
%   `lift` and `side_force` are accepted for API compatibility but are NOT used:
%   deriving a non-zero angle-of-attack / sideslip from them has no definition in
%   the schema or the existing toolbox, so it is intentionally left as the
%   zero-AoA special case rather than invented here.
%
% References:
%

function varargout = claunch2vel(launch, launch_vel, lift, side_force, lat0, lon0, alt0, options)

    arguments
        launch (3, 1) double
        launch_vel (3, 1) double
        lift (3, 1) double %#ok
        side_force (3, 1) double %#ok
        lat0 {mustBeReal}
        lon0 {mustBeReal}
        alt0 {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
        options.spheroid (1, 1) refEllipsoid = refEllipsoid('wgs84', 'm')
    end

    [roll, pitch, yaw] = unedv2euler(launch_vel, 'angleUnit', options.angleUnit);

    launch2vel = rlaunch2vel(roll, pitch, yaw, 'angleUnit', options.angleUnit);
    [ex, ey, ez] = cgeodetic2ecef(lat0, lon0, alt0, 'angleUnit', options.angleUnit, 'spheroid', options.spheroid);
    ECEF_g = [ex; ey; ez];
    velocity = launch2vel * (launch + ECEF_g);

    if nargout == 1
        varargout{1} = velocity;
    elseif nargout == 3
        varargout{1} = velocity(1);
        varargout{2} = velocity(2);
        varargout{3} = velocity(3);
    else
        error('Invalid Number of Output Arguments');
    end

end
