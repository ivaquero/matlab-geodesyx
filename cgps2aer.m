% Coordinate Transformation: Aircraft GPS ==>  tAER
%
% Syntax:
%   varargout = cgps2aer(GPS, lat0, lon0, alt0, options)
%
% Input:
%   GPS                     Target's GPS coordinates: time, latitude, longitude, altitude in [ms, degree, degree, m]
%   options.spheroid        Reference ellipsoid model: 'wgs84' (default) or 'grs80'
%   options.angleUnit       Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut    Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout               Target's tAER coordinates: time, azimuth, elevation, slant range in [ms, deg, deg, m]
%
% Description:
%   Convert the aircraft's GPS data to a spherical coordinate system centered on radar station
%   step 1: WGS84 ==> ECEF
%   step 2: ECEF  ==> ENU
%   step 3: ENU   ==> tAER
% Attention:
%

function varargout = cgps2aer(GPS, lat0, lon0, alt0, options)

    arguments
        GPS {mustBeReal}
        lat0 {mustBeReal}
        lon0 {mustBeReal}
        alt0 {mustBeReal}
        options.spheroid (1, 1) refEllipsoid = refEllipsoid('wgs84', 'm')
        options.angleUnit (1, 1) string = 'degrees'
        options.angleUnitOut (1, 1) string = 'degrees'
    end

    time = GPS(1);
    lat = GPS(3);
    lon = GPS(2);
    alt = GPS(4);

    [x, y, z] = cgeodetic2ecef(lat, lon, alt, 'spheroid', options.spheroid, 'angleUnit', options.angleUnit);
    [xEast, yNorth, zUp] = cecef2enu(x, y, z, lat0, lon0, alt0, 'spheroid', options.spheroid, 'angleUnit', options.angleUnit);
    [az, ~, rslant] = cenu2aer(xEast, yNorth, zUp, 'angleUnitOut', options.angleUnitOut);

    % Use the measurement elevation
    elev = calc_hr2elev(alt, rslant, alt0, 'angleUnit', options.angleUnit, 'angleUnitOut', options.angleUnitOut);

    if nargout == 1
        varargout{1} = [time, az, elev, rslant];
    elseif nargout == 4
        varargout{1} = time(1);
        varargout{2} = az(2);
        varargout{3} = elev(3);
        varargout{4} = rslant(4);
    else
        error('Invalid Number of Output Arguments');
    end

end
