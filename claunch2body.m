% Coordinate Transformation: Launch ==> Body
%
% Syntax:
%   varargout = claunch2body(launch, launch_vel, lat0, lon0, alt0, options)
%
% Input:
%   launch                          Target's launch coordinates in [m, m, m]
%   launch_vel                      Target's launch velocity in [m/s, m/s, m/s]
%   dt                              Time interval in seconds
%   [lat0, lon0, alt0]              Reference's geodetic coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's body coordinates in [m, m, m]
% Attention:
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

    [roll, pitch, yaw] = unedv2euler(launch_vel, dt);

    launch2body = rotate_x(roll, 'angleUnit', options.angleUnit) * rotate_y(pitch, 'angleUnit', options.angleUnit) * rotate_z(yaw, 'angleUnit', options.angleUnit);

    ECEF_g = cgeodetic2ecef(lat0, lon0, alt0, 'angleUnit', options.angleUnit, 'spheroid', options.spheroid);
    body = launch2body * launch + ECEF_g;

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
