function quat_conj = quat_conj(quat)
    quat_conj = [quat(:, 1) -quat(:, 2) -quat(:, 3) -quat(:, 4)];
end
