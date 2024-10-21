% Rotation Matrix: Rotate Around Y-Axis
%
% Syntax:
%   Ry = rotate_y(beta, options)
%
% Input:
%   beta                        Rotation angle in deg
% Output:
%   Ry                          Rotation matrix
% Attention:
%

function Ry = rotate_y(beta, options)

    arguments
        beta {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    switch options.angleUnit
        case 'degrees'
            beta = deg2rad(beta);
        case 'radians'
        otherwise , error('Incorrect Input Angle Unit!');
    end

    Ry = [ ...
              cos(beta), 0, -sin(beta); ...
              0, 1, 0; ...
              sin(beta), 0, cos(beta)];

end
