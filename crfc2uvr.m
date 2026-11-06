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

function varargout = crfc2uvr(rfc)

    arguments
        rfc (3, 1) double
    end

    x = rfc(1);
    y = rfc(2);
    z = rfc(3);

    % slant range
    rslant = hypot(hypot(x, y), z);
    % direction cosine along x (unitless)
    u = x / rslant;
    % direction cosine along y (unitless)
    v = y / rslant;

    uvr = [u, v, rslant];

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
