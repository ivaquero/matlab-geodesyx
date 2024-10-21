% Coordinate Transformation:Body ==> ENU
%
% Syntax:
%   varargout = cbody2launch(body, lift, lat0, lon0, alt0, options)
%
% Input:
%   body                        Target's body coordinates in [m, m, m]
%   angles                      Target's body velocity in [m/s, m/s, m/s]
%   [lat0, lon0, alt0]          Reference's geodetic coordinates in [deg, deg, m]
%   options.spheroid            Reference ellipsoid model: 'wgs84' (default) or 'grs80'
%   options.angleUnit           Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                   Target's ENU coordinates in [m, m, m]
% Attention:
%
% References:
%

function varargout = cbody2launch(body, angles, lat0, lon0, alt0, options)

    arguments
        body (3, 1) double
        angles (3, 1) double
        lat0 {mustBeReal}
        lon0 {mustBeReal}
        alt0 {mustBeReal}
        options.spheroid (1, 1) refEllipsoid = refEllipsoid('wgs84', 'm')
        options.angleUnit (1, 1) string = 'degrees'
    end

    roll = angles(1);
    pitch = angles(2);
    yaw = angles(3);

    launch2body = rotate_x(-roll, 'angleUnit', options.angleUnit) * rotate_y(-pitch, 'angleUnit', options.angleUnit) * rotate_z(-yaw, 'angleUnit', options.angleUnit);

    ECEF_g = cgeodetic2ecef(lat0, lon0, alt0, 'angleUnit', options.angleUnit, 'spheroid', options.spheroid);
    launch = launch2body' * body - ECEF_g;

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
