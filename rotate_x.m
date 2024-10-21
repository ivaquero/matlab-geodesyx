% Rotation Matrix: Rotate Around X-Axis
%
% Syntax:
%   Rx = rotate_x(alpha, options)
%
% Input:
%   alpha                       Rotation angle in deg
% Output:
%   Rx                          Rotation matrix
% Attention:
%

function Rx = rotate_x(alpha, options)

    arguments
        alpha {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    switch options.angleUnit
        case 'degrees'
            alpha = deg2rad(alpha);
        case 'radians'
        otherwise , error('Incorrect Input Angle Unit!');
    end

    Rx = [ ...
              1, 0, 0; ...
              0, cos(alpha), sin(alpha); ...
              0, -sin(alpha), cos(alpha)];
end
