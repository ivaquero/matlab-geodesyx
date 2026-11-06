% Rotation Matrix: Launch/Ground ==> Velocity
%
% Syntax:
%   launch2vel = rlaunch2vel(roll, pitch, yaw, options)
%
% Input:
%   roll                        Bank angle about the velocity axis
%   pitch                       Flight-path angle (velocity elevation)
%   yaw                         Heading / track angle (velocity azimuth)
%   options.angleUnit           Unit of the input angles: 'degrees' (default)
%                               or 'radians'
% Output:
%   launch2vel                  Rotation matrix taking a vector expressed in the
%                               launch/ground (ENU) frame into the velocity frame
% Attention:
%   RECONSTRUCTED helper. The original stub called an undefined `rlaunch2vel`.
%   The schema (docs/geodesyx.drawio.png) gives Ground->Body as
%   R_x(-phi) R_y(-psi) R_z(-gamma); the ground->velocity rotation has the same
%   structure with (roll, pitch, yaw) = (bank, flight-path, heading). This uses
%   the toolbox's own `rotate_x/y/z` primitives, so it is the exact transpose
%   inverse of the matching velocity->ground rotation and consistent with
%   `cbody2launch`. With zero angle-of-attack / sideslip the velocity frame
%   coincides with the body frame, i.e. rlaunch2vel == launch2body.
%
% References:
%

function launch2vel = rlaunch2vel(roll, pitch, yaw, options)

    arguments
        roll {mustBeReal}
        pitch {mustBeReal}
        yaw {mustBeReal}
        options.angleUnit (1, 1) string = 'degrees'
    end

    launch2vel = rotate_x(-roll, 'angleUnit', options.angleUnit) * ...
                 rotate_y(-pitch, 'angleUnit', options.angleUnit) * ...
                 rotate_z(-yaw, 'angleUnit', options.angleUnit);

end
