% Coordinate Transformation: Launch ==> ECEF
%
% Syntax:
%   varargout = claunch2ecef(launch, A_T, lat0, lon0, alt0, options)
%
% Input:
%   launch                          Target's launch coordinates in [m, m, m]
%   [A_T, B_T, L_T]                 Declination angle between coordinate systems in [deg, deg, deg]
%   dt                              Time interval in seconds
%   [lat0, lon0, alt0]              Reference's geodetic coordinates in [deg, deg, m]
%   options.angleUnit               Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                       Target's body coordinates in [m, m, m]
% Attention:
%
% References:
%

function varargout = claunch2ecef(launch, A_T, B_T, L_T, lat0, lon0, alt0, options)

    arguments
        launch (3, 1) double
        A_T {mustBeReal}
        B_T {mustBeReal}
        L_T {mustBeReal}
        lat0 {mustBeReal}
        lon0 {mustBeReal}
        alt0 {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
        options.spheroid (1, 1) refEllipsoid = refEllipsoid('wgs84', 'm')
    end

    % Ground -> ECEF rotation. The schema (docs/geodesyx.drawio.png) labels this
    % edge R_y(-pi/2 - A_T) R_z(B_T) R_z(L_T - pi/2); the middle R_z(B_T) is a
    % diagram typo -- the inverse edge (ECEF -> Ground) uses R_x(-B_T), so the
    % correct middle term is R_x(B_T). In the toolbox's passive rotate_* notation
    % (rotate_*(a) == R_*(-a)) that is exactly rotate_x(-B_T) below.
    rlaunch2ecef = rotate_y(pi / 2 + A_T, 'angleUnit', options.angleUnit) * rotate_x(-B_T, 'angleUnit', options.angleUnit) * rotate_z(pi / 2 - L_T, 'angleUnit', options.angleUnit);

    [ex, ey, ez] = cgeodetic2ecef(lat0, lon0, alt0, 'angleUnit', options.angleUnit, 'spheroid', options.spheroid);
    ECEF_g = [ex; ey; ez];
    ecef = rlaunch2ecef * launch + ECEF_g;

    if nargout == 1
        varargout{1} = ecef;
    elseif nargout == 3
        varargout{1} = ecef(1);
        varargout{2} = ecef(2);
        varargout{3} = ecef(3);
    else
        error('Invalid Number of Output Arguments');
    end

end
