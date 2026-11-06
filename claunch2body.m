% Coordinate Transformation: Launch ==> Body
%
% Syntax:
%   varargout = claunch2body(launch, launch_vel, lat0, lon0, alt0, options)
%
% Input:
%   launch                          Target's launch (ground/ENU) coordinates in [m, m, m]
%   launch_vel                      Target's velocity in the launch frame in
%                                   [m/s, m/s, m/s] as [East; North; Up]
%   [lat0, lon0, alt0]              Reference's geodetic coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
%   options.spheroid                Reference ellipsoid (default wgs84)
% Output:
%   varargout                       Target's body coordinates in [m, m, m]
% Attention:
%   RECONSTRUCTED. The body attitude is inferred from the velocity vector via
%   `unedv2euler` (heading + flight-path angle, zero bank), then the launch->body
%   rotation `rotate_x(-roll) * rotate_y(-pitch) * rotate_z(-yaw)` is applied.
%   This is the exact inverse of `cbody2launch`:
%       body = launch2body * (launch + ECEF_g)
%   so that cbody2launch(claunch2body(launch, v), angles) recovers `launch`.
%   A non-zero bank angle cannot be recovered from velocity alone; use
%   `cbody2launch` with explicit `angles` when the full attitude is known.
%
% References:
%

function varargout = claunch2body(launch, launch_vel, lat0, lon0, alt0, options)

    arguments
        launch (3, 1) double
        launch_vel (3, 1) double
        lat0 {mustBeReal}
        lon0 {mustBeReal}
        alt0 {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
        options.spheroid (1, 1) refEllipsoid = refEllipsoid('wgs84', 'm')
    end

    [roll, pitch, yaw] = unedv2euler(launch_vel, 'angleUnit', options.angleUnit);

    launch2body = rotate_x(-roll, 'angleUnit', options.angleUnit) * ...
                  rotate_y(-pitch, 'angleUnit', options.angleUnit) * ...
                  rotate_z(-yaw, 'angleUnit', options.angleUnit);

    [ex, ey, ez] = cgeodetic2ecef(lat0, lon0, alt0, 'angleUnit', options.angleUnit, 'spheroid', options.spheroid);
    ECEF_g = [ex; ey; ez];
    body = launch2body * (launch + ECEF_g);

    if nargout == 1
        varargout{1} = body;
    elseif nargout == 3
        varargout{1} = body(1);
        varargout{2} = body(2);
        varargout{3} = body(3);
    else
        error('Invalid Number of Output Arguments');
    end

end
