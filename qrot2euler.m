% from paper: "Adaptive Filter for a Miniature MEMS Based Attitude and
% Heading Reference System" by Wang et al, IEEE.
function euler = qrot2euler(rot)

    phi = atan2(rot(3, 2, :), rot(3, 3, :));
    theta = -atan(rot(3, 1, :) ./ sqrt(1 - rot(3, 1, :) .^ 2));
    psi = atan2(rot(2, 1, :), rot(1, 1, :));

    euler = [phi(1, :)' theta(1, :)' psi(1, :)'];
end
