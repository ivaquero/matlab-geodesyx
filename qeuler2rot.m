function rot = qeuler2rot(phi, theta, psi)
    rot(1, 1, :) = cos(psi) .* cos(theta);
    rot(1, 2, :) = -sin(psi) .* cos(phi) + cos(psi) .* sin(theta) .* sin(phi);
    rot(1, 3, :) = sin(psi) .* sin(phi) + cos(psi) .* sin(theta) .* cos(phi);

    rot(2, 1, :) = sin(psi) .* cos(theta);
    rot(2, 2, :) = cos(psi) .* cos(phi) + sin(psi) .* sin(theta) .* sin(phi);
    rot(2, 3, :) = -cos(psi) .* sin(phi) + sin(psi) .* sin(theta) .* cos(phi);

    rot(3, 1, :) = -sin(theta);
    rot(3, 2, :) = cos(theta) .* sin(phi);
    rot(3, 3, :) = cos(theta) .* cos(phi);
end
