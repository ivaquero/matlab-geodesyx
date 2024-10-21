% Coordinate Transformation: AER ==> ECI
%
% Syntax:
%   varargout = caer2eci(utc, az, elev, rslant, lat0, lon0, alt0, options)
%
% Input:
%   utc                     UTC time in datetime
%   [az, elev, rslant]      Target's spherical coordinates in [deg, deg, m]
%   [lat0, lon0, alt0]      Reference's geodetic coordinates in [deg, deg, m]
%   options.spheroid        Reference ellipsoid model: 'wgs84' (default) or 'grs80'
%   options.angleUnit       Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut    Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout               Target's inertial coordinates in [m, m, m]
% Attention:
%   Since 'cecef2eci()' only considers rotation, the error may be 1%~10%; if longitude is required, you can use the MATLAB official function, 'ecef2eci()'

function varargout = caer2eci(utc, az, elev, rslant, lat0, lon0, alt0, options)

    arguments
        utc datetime
        az {mustBeReal}
        elev {mustBeReal}
        rslant {mustBeReal, mustBeNonnegative}
        lat0 {mustBeReal}
        lon0 {mustBeReal}
        alt0 {mustBeReal}
        options.spheroid (1, 1) refEllipsoid = refEllipsoid('wgs84', 'm')
        options.angleUnit (1, 1) string = 'degrees'
    end

    [x, y, z] = caer2ecef(az, elev, rslant, lat0, lon0, alt0, 'spheroid', options.spheroid, 'angleUnit', options.angleUnit);
    eci = cecef2eci(utc, x, y, z);

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
