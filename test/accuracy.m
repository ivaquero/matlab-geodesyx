% CLEAN WORKSPACE 清理
clear; close all; clc;

% LOAD TOOLBOX 加载库路径
path(path, strcat(pwd, '/..'));

% REFERENCE POINT COORDINATES 参考点（站址）坐标
lat0 = 31.67749919;
lon0 = 116.75590625;
alt0 = 72.4121;

% TARGET POINT COORDINATES 目标点坐标
latz = 31.635400994;
lonz = 116.701204066;
altz = 464.799;

syms pitch roll yaw pi;

L = rotate_x(roll) * rotate_y(pitch) * rotate_z(yaw);
disp(L);
% L2 = rotate_x(0) * rotate_z(az) * rotate_y(-phi) * rotate_z(psi);
% disp(L2)
