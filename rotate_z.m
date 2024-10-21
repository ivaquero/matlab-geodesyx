% Rotation Matrix: Rotate Around Z-Axis
%
% Syntax:
%   Rz = rotate_z(gamma, options)
%
% Input:
%   gamma                       Rotation angle in deg
% Output:
%   Rz                          Rotation matrix
% Attention:
%

function Rz = rotate_z(gamma, options)

    arguments
        gamma {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    switch options.angleUnit
        case 'degrees'
            gamma = deg2rad(gamma);
        case 'radians'
        otherwise , error('Incorrect Input Angle Unit!');
    end

    Rz = [ ...
              cos(gamma), sin(gamma), 0; ...
              -sin(gamma), cos(gamma), 0; ...
              0, 0, 1];
end
