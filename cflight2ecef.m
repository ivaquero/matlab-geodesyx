% Coordinate Transformation: Flight ==> ECEF, 6-dimensional state (position + velocity)
%
% Syntax:
%   varargout = cflight2ecef(r, lat, lon, v_radial, chi, gamma, options)
%
% Input:
%   r                           Target's geocentric distance in meters
%   [lat, lon]                  Target's geodetic coordinates in [deg, deg]
%   [v_radial, chi, gamma]      Target's radial velocity, azimuth and inclination in [m/s, deg, deg]
%   options.angleUnit           Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                   Target's ECEF coordinates in [m, m, m, m/s, m/s, m/s]
% Attention:
%
% References:
%

function varargout = cflight2ecef(r, lat, lon, v_radial, chi, gamma, options)

    arguments
        r {mustBeReal}
        lat {mustBeReal}
        lon {mustBeReal}
        v_radial {mustBeReal}
        chi {mustBeReal}
        gamma {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    switch options.angleUnit
        case 'degrees'
            lat = deg2rad(lat);
            lon = deg2rad(lon);
            chi = deg2rad(chi);
            gamma = deg2rad(gamma);
        case 'radians'
        otherwise , error('Incorrect Input Angle Unit!');
    end

    % ECEF coordinates
    x = r .* cos(lat) .* cos(lon);
    y = r .* cos(lat) .* sin(lon);
    z = r .* sin(lat);

    [lat0, lon0, ~] = cecef2geodetic(x, y, z, options);

    % NED coordinates
    vn = v_radial .* cos(gamma) .* cos(chi);
    ve = v_radial .* cos(gamma) .* sin(chi);
    vd = -v_radial .* sin(gamma);

    [vx, vy, vz] = cenu2ecefv(vn, ve, -vd, lat0, lon0, 'angleUnit', options.angleUnit);

    if nargout == 1
        varargout{1} = [x, y, z, vx, vy, vz];
    elseif nargout == 2
        varargout{1} = [x, y, z];
        varargout{2} = [vx, vy, vz];
    elseif nargout == 6
        varargout{1} = x;
        varargout{2} = y;
        varargout{3} = z;
        varargout{4} = vx;
        varargout{5} = vy;
        varargout{6} = vz;
    else
        error('Invalid Number of Output Arguments');
    end

end
