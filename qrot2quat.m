function q = qrot2quat(rot)
    [~, ~, numR] = size(rot);
    q = zeros(numR, 4);
    K = zeros(4, 4);

    for i = 1:numR
        K(1, 1) = (1/3) * (rot(1, 1, i) - rot(2, 2, i) - rot(3, 3, i));
        K(1, 2) = (1/3) * (rot(2, 1, i) + rot(1, 2, i));
        K(1, 3) = (1/3) * (rot(3, 1, i) + rot(1, 3, i));
        K(1, 4) = (1/3) * (rot(2, 3, i) - rot(3, 2, i));
        K(2, 1) = (1/3) * (rot(2, 1, i) + rot(1, 2, i));
        K(2, 2) = (1/3) * (rot(2, 2, i) - rot(1, 1, i) - rot(3, 3, i));
        K(2, 3) = (1/3) * (rot(3, 2, i) + rot(2, 3, i));
        K(2, 4) = (1/3) * (rot(3, 1, i) - rot(1, 3, i));
        K(3, 1) = (1/3) * (rot(3, 1, i) + rot(1, 3, i));
        K(3, 2) = (1/3) * (rot(3, 2, i) + rot(2, 3, i));
        K(3, 3) = (1/3) * (rot(3, 3, i) - rot(1, 1, i) - rot(2, 2, i));
        K(3, 4) = (1/3) * (rot(1, 2, i) - rot(2, 1, i));
        K(4, 1) = (1/3) * (rot(2, 3, i) - rot(3, 2, i));
        K(4, 2) = (1/3) * (rot(3, 1, i) - rot(1, 3, i));
        K(4, 3) = (1/3) * (rot(1, 2, i) - rot(2, 1, i));
        K(4, 4) = (1/3) * (rot(1, 1, i) + rot(2, 2, i) + rot(3, 3, i));
        [V, D] = eig(K);
        [~, idx] = max(diag(D));
        v = V(:, idx).';              % (x, y, z, w)
        q(i, :) = [v(4) v(1) v(2) v(3)];   % reorder to (w, x, y, z)
        if q(i, 1) < 0
            q(i, :) = -q(i, :);       % enforce w >= 0
        end
    end

end
