% Coordinate Transformation: ECEF ==> Flight
%
% Syntax:
%   varargout = cecef2flight(x, y, z, vx, vy, vz)
%
% Input:
%   [x, y, z, vx, vy, vz]       Target's ECEF coordinates in [m, m, m, m/s, m/s, m/s]
%   options.spheroid            Reference ellipsoid model: 'wgs84' (default) or 'grs80'
% Output:
%   r                           Target's geocentric distance in meters
%   [lat, lon]                  Target's geodetic coordinates in [deg, deg]
%   [v_radial, chi, gamma]      Target's radial velocity, azimuth and inclination in [m/s, deg, deg]
% Attention:
%
% References:
%

function varargout = cecef2flight(x, y, z, vx, vy, vz)

    arguments
        x {mustBeReal}
        y {mustBeReal}
        z {mustBeReal}
        vx {mustBeReal}
        vy {mustBeReal}
        vz {mustBeReal}
    end

    % position
    r = sqrt(x ^ 2 + y ^ 2 + z ^ 2);
    lat = asin(z ./ r);
    lon = mod(atan2(y, x), 2 * pi);

    [lat0, lon0, ~] = cecef2geodetic(x, y, z, 'spheroid', options.spheroid);

    % velocity
    v_radial = sqrt(vx ^ 2 + vy ^ 2 + vz ^ 2);
    [ve, vn, vu] = cecef2enuv(vx, vy, vz, lat0, lon0);

    chi = mod(atan2(ve, vn), 2 * pi);
    gamma = asin(vu / v_radial);

    switch options.angleUnitOut
        case 'degrees'
            lat = deg2rad(lat);
            lon = deg2rad(lon);
            chi = deg2rad(chi);
            gamma = deg2rad(gamma);
        case 'radians'
        otherwise , error('Incorrect Output Angle Unit!');
    end

    if nargout == 1
        varargout{1} = [r, lat, lon, v_radial, chi, gamma];
    elseif nargout == 2
        varargout{1} = [r, lat, lon];
        varargout{2} = [v_radial, chi, gamma];
    elseif nargout == 6
        varargout{1} = r;
        varargout{2} = lat;
        varargout{3} = lon;
        varargout{4} = v_radial;
        varargout{5} = chi;
        varargout{6} = gamma;
    else
        error('Invalid Number of Output Arguments');
    end

end
