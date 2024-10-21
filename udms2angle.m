% Unit Conversion: Degree-Minute-Second => Angle
%
% Syntax:
%   angle = udms2angle(dms, options)
%
% Input:
%   dms                         Degree-Minute-Second
%   options.angleUnitOut        Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   angle	                    Angle
%
% References:
%

function angle = udms2angle(dms, options)

    arguments
        dms (3, 1) double
        options.angleUnitOut (1, 1) string = 'degrees'
    end

    sgn = 1 - 2 * any(dms < 0, 2);
    angleInDegrees ...
        = sgn .* (abs(dms(:, 1)) + (abs(dms(:, 2)) + abs(dms(:, 3)) / 60) / 60);

    switch options.angleUnitOut
        case 'degrees'
        case 'radians'
            angle = deg2rad(angleInDegrees);
        otherwise , error('Incorrect Input Angle Unit!');
    end

end
