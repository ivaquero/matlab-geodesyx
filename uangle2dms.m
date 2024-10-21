% Unit Conversion: Angle => Degree-Minute-Second
%
% Syntax:
%   dms = uangle2dms(angle, options)
%
% Input:
%   angle	                    Angle
%   options.angleUnit           Input's angle unit in 'degrees' (default) or 'radians'
% Output:
%   dms                         Degree-Minute-Second
%
% References:
%
% See also:
%

function dms = uangle2dms(angle, options)

    arguments
        angle {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    switch options.angleUnit
        case 'degrees'
        case 'radians'
            angleInDegrees = rad2deg(angle);
        otherwise , error('Incorrect Input Angle Unit!');
    end

    % 构建 dms 数组
    minutes = 60 * rem(angleInDegrees, 1);
    dms = [fix(angleInDegrees) fix(minutes) 60 * rem(minutes, 1)];

    % 如果 degrees or minutes < 0，则翻转符号
    negativeDorM = any(dms(:, 1:2) < 0, 2);
    dms(negativeDorM, 3) = -dms(negativeDorM, 3);

    % 如果 degrees < 0，则翻转符号
    negativeD = (dms(:, 1) < 0);
    dms(negativeD, 2) = -dms(negativeD, 2);

end
