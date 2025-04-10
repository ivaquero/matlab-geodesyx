function rot = qangle2rot(axis, angle)
    kx = axis(:, 1);
    ky = axis(:, 2);
    kz = axis(:, 3);
    cT = cos(angle);
    sT = sin(angle);
    vT = 1 - cos(angle);

    rot(1, 1, :) = kx .* kx .* vT + cT;
    rot(1, 2, :) = kx .* ky .* vT - kz .* sT;
    rot(1, 3, :) = kx .* kz .* vT + ky .* sT;

    rot(2, 1, :) = kx .* ky .* vT + kz .* sT;
    rot(2, 2, :) = ky .* ky .* vT + cT;
    rot(2, 3, :) = ky .* kz .* vT - kx .* sT;

    rot(3, 1, :) = kx .* kz .* vT - ky .* sT;
    rot(3, 2, :) = ky .* kz .* vT + kx .* sT;
    rot(3, 3, :) = kz .* kz .* vT + cT;
end
