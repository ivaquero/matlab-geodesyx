% Coordinate Transformation: RFC ==> UVR
%
%   varargout = crfc2uvr(rfc, options)
% Syntax:
%
% Input:
%   rfc                         Target's front coordinates in [m, m, m]
%   options.angleUnitOut        Output's angle unit in 'degrees' (default) or 'radians'
% Output:
%   varargout                   Target's ENU coordinates in [m, m, m]
% Attention:
%
% References:
%

function varargout = crfc2uvr(rfc, options)

    arguments
        rfc (3, 1) double
        options.angleUnit (1, 1) string = 'degrees'
    end

    x = rfc(1);
    y = rfc(2);
    z = rfc(3);

    % slant range
    rslant = sqrt(x ^ 2 + y ^ 2 + z ^ 2);
    % azimuth
    u = x / rslant;
    % elevation
    v = y / rslant;

    switch options.angleUnitOut
        case 'degrees'
            u = rad2deg(u);
            v = rad2deg(v);
        case 'radians'
        otherwise , error('Incorrect Output Angle Unit!');
    end

    if nargout == 1
        varargout{1} = uvr;
    elseif nargout == 3
        varargout{1} = u;
        varargout{2} = v;
        varargout{3} = rslant;
    else
        error('Invalid Number of Output Arguments');
    end

end
