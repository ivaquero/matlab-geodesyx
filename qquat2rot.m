function rot = qquat2rot(quat)
    [rows, ~] = size(quat);
    rot = zeros(3, 3, rows);
    rot(1, 1, :) = 2 .* quat(:, 1) .^ 2 - 1 + 2 .* quat(:, 2) .^ 2;
    rot(1, 2, :) = 2 .* (quat(:, 2) .* quat(:, 3) + quat(:, 1) .* quat(:, 4));
    rot(1, 3, :) = 2 .* (quat(:, 2) .* quat(:, 4) - quat(:, 1) .* quat(:, 3));
    rot(2, 1, :) = 2 .* (quat(:, 2) .* quat(:, 3) - quat(:, 1) .* quat(:, 4));
    rot(2, 2, :) = 2 .* quat(:, 1) .^ 2 - 1 + 2 .* quat(:, 3) .^ 2;
    rot(2, 3, :) = 2 .* (quat(:, 3) .* quat(:, 4) + quat(:, 1) .* quat(:, 2));
    rot(3, 1, :) = 2 .* (quat(:, 2) .* quat(:, 4) + quat(:, 1) .* quat(:, 3));
    rot(3, 2, :) = 2 .* (quat(:, 3) .* quat(:, 4) - quat(:, 1) .* quat(:, 2));
    rot(3, 3, :) = 2 .* quat(:, 1) .^ 2 - 1 + 2 .* quat(:, 4) .^ 2;
end
