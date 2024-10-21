% Coordinate Transformation: ECI ==> AER
%
% Syntax:
%   varargout = ceci2aer(utc, x_eci, y_eci, z_eci, lat0, lon0, alt0, options)
%
% Input:
%   utc                     UTC time in 'yyyy-mm-dd HH:MM:SS'
%   [x_eci, y_eci, z_eci]   Target's inertial coordinates in [m, m, m]
%   [lat0, lon0, alt0]      Reference's geodetic coordinates in [deg, deg, m]
%   options.spheroid        Reference ellipsoid model: 'wgs84' (default) or 'grs80'
%   options.angleUnit       Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut    Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout               Target's spherical coordinates in [deg, deg, m]
% Attention:
%

function varargout = ceci2aer(utc, x_eci, y_eci, z_eci, lat0, lon0, alt0, options)

    arguments
        utc datetime
        x_eci {mustBeReal, mustBeEqualSize(utc, x_eci)}
        y_eci {mustBeReal, mustBeEqualSize(utc, y_eci)}
        z_eci {mustBeReal, mustBeEqualSize(utc, z_eci)}
        lat0 {mustBeReal}
        lon0 {mustBeReal}
        alt0 {mustBeReal}
        options.spheroid (1, 1) refEllipsoid = refEllipsoid('wgs84', 'm')
        options.angleUnit (1, 1) string = 'degrees'
        options.angleUnitOut (1, 1) string = 'degrees'
    end

    [x_eci, y_eci, z_eci] = ceci2ecef(utc, x_eci, y_eci, z_eci);
    [az, elev, rslant] = cecef2aer(x_eci, y_eci, z_eci, lat0, lon0, alt0, 'spheroid', options.spheroid, 'angleUnitOut', options.angleUnitOut);

    if nargout == 1
        varargout{1} = [az, elev, rslant];
    elseif nargout == 3
        varargout{1} = az;
        varargout{2} = elev;
        varargout{3} = rslant;
    else
        error('Invalid Number of Output Arguments');
    end

end
