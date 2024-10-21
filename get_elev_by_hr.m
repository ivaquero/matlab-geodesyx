% Calculation: Altitude, Slant Range, Station Height ==> Elevation
%
% Syntax:
%   elev = get_elev_by_hr(alt, rslant, alt0, options)
%
% Input:
%   rslant                  Target's slant range in meters
%   alt                     Target's altitude in meters
%   alt0  	                Reference's altitude in meters
%   options.angleUnit       Input's angle unit in 'degrees' (default) or 'radians'
%   options.angleUnitOut    Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   elev                    Target's elevation in deg
% Attention:
%

function elev = get_elev_by_hr(alt, rslant, alt0, options)

    arguments
        alt {mustBeReal}
        rslant {mustBeReal, mustBeNonnegative}
        alt0 {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
        options.angleUnitOut (1, 1) string = 'degrees'
    end

    Rmean = options.spheroid.MeanRadius;
    % equivalent Earth radius (m)
    Rt = Rmean * 4/3;

    switch options.angleUnit
        case 'degrees'
        case 'radians'
            alt = rad2deg(alt);
            alt0 = rad2deg(alt0);
        otherwise , error('Incorrect Input Angle Unit!');
    end

    dalt = (alt - alt0);
    x = (dalt - (rslant .* rslant ./ (2 * Rt))) ./ rslant;
    elev = asind(x);

    % When height is out of range, the calculated angle is an imaginary number
    % and the angle is forced to be 90 degrees
    if ~isempty(find(abs(x) > 1, 1))
        disp('Altitude > Slant Range, Set Elevation to 90 degree!\n');
        elev(ix) = 90;
    end

    switch options.angleUnitOut
        case 'degrees'
        case 'radians'
            elev = deg2rad(elev);
        otherwise , error('Incorrect Output Angle Unit!');
    end

end
