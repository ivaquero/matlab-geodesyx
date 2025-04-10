function quat = qangle2quat(axis, angle)
    quat0 = cos(angle ./ 2);
    quat1 = -axis(:, 1) * sin(angle ./ 2);
    quat2 = -axis(:, 2) * sin(angle ./ 2);
    quat3 = -axis(:, 3) * sin(angle ./ 2);
    quat = [quat0 quat1 quat2 quat3];
end
