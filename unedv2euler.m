% Euler Angles From A Velocity Vector (Launch/Ground Frame)
%
% Syntax:
%   [roll, pitch, yaw] = unedv2euler(vel, options)
%
% Input:
%   vel                         Velocity vector in the launch/ground (ENU) frame
%                               as [East; North; Up] in [m/s, m/s, m/s]
%   options.angleUnit           Unit of the returned angles: 'degrees' (default)
%                               or 'radians'
% Output:
%   roll                        Bank angle about the velocity axis
%   pitch                       Flight-path angle (velocity elevation above local
%                               horizontal)
%   yaw                         Heading / track angle (velocity azimuth, measured
%                               clockwise from true north)
% Attention:
%   RECONSTRUCTED helper. The original stub called an undefined `unedv2euler`
%   with an undefined `dt`. The schema (docs/geodesyx.drawio.png) expresses the
%   frame rotations in terms of named angles but does not define how to obtain
%   them from a velocity vector, so this follows the toolbox's own conventions:
%     * heading and flight-path angle use the geodesy azimuth/elevation
%       convention (atan2(East, North) clockwise from north, atan2(Up, horizontal)),
%       matching matlab-geodesy `cenu2aer` / `cen2ar`;
%     * the bank angle cannot be inferred from a velocity vector alone, so it is
%       returned as zero (wings-level / no roll about the velocity axis).
%   Callers that need a non-zero bank must supply the Euler angles explicitly
%   (see cbody2launch, which takes `angles` directly).
%
% References:
%

function [roll, pitch, yaw] = unedv2euler(vel, options)

    arguments
        vel (3, 1) double
        options.angleUnit (1, 1) string = 'degrees'
    end

    % heading (yaw): azimuth clockwise from true north (y-axis), geodesy convention
    yaw = mod(atan2(vel(1), vel(2)), 2 * pi);

    % flight-path angle (pitch): elevation of the velocity above the local horizontal
    pitch = atan2(vel(3), hypot(vel(1), vel(2)));

    % bank (roll): not observable from a single velocity vector -> zero
    roll = 0;

    switch options.angleUnit
        case 'degrees'
            roll = rad2deg(roll);
            pitch = rad2deg(pitch);
            yaw = rad2deg(yaw);
        case 'radians'
        otherwise , error('Incorrect Output Angle Unit!');
    end

end
