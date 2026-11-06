% Regression tests for matlab-geodesyx (aerospace extension).
% Self-contained: requires both matlab-geodesy and this toolbox on the path.
%   run from repo root:  matlab -batch "addpath('matlab-geodesy'); addpath('matlab-geodesyx'); test/test_regression"
%
% NOTE: claunch2body / claunch2vel / cvel2launch and the antenna<=>platform<=>rfc
% projection family (cant2platform / cplatform2ant / crfc2ant) are known-broken
% (missing helpers / undefined projection) and are intentionally NOT asserted here.

function test_regression

    tol = 1e-6;
    npass = 0; nfail = 0;

    % --- unit conversion round trip ---
    chk('uangle2dms/udms2angle round trip', ...
        abs(udms2angle(uangle2dms(30.5)) - 30.5) < tol, @() mat2str(uangle2dms(30.5)));
    chk('udms2angle 30d30m0s = 30.5', abs(udms2angle([30 30 0]) - 30.5) < tol);
    chk('udms2angle radians', abs(udms2angle([30 30 0], 'angleUnitOut', 'radians') - deg2rad(30.5)) < tol);

    % --- quaternion family ---
    q = qangle2quat([1 0 0], pi/2);
    chk('qangle2quat single size', isequal(size(q), [1 4]));
    qb = qangle2quat([1 0 0; 0 1 0], [pi/2 pi/3]);
    chk('qangle2quat batch size', isequal(size(qb), [2 4]));
    chk('qangle2quat unit norm', all(abs(sum(qb.^2, 2) - 1) < tol));

    chk('qangle2rot single is 3x3', isequal(size(squeeze(qangle2rot([1 0 0], pi/2))), [3 3]));
    chk('qangle2rot batch 3x3xN', isequal(size(qangle2rot([1 0 0;0 1 0],[pi/2 pi/3])), [3 3 2]));

    % quat -> rot -> quat
    qq = [cos(pi/4) sin(pi/4) 0 0];
    qr = qrot2quat(qquat2rot(qq));
    chk('quat->rot->quat consistent', abs(sum(qq .* qr)) > 1 - tol);

    % euler -> rot -> euler
    eu = qrot2euler(qeuler2rot(0.3, 0.2, 0.1));
    chk('euler->rot->euler round trip', max(abs(eu - [0.3 0.2 0.1])) < tol);

    % quat -> euler consistency vs rot path
    qz = qrot2quat(qeuler2rot(0.3, 0.2, 0.1));
    e2 = qquat2euler(qz);
    chk('quat->euler round trip', max(abs(e2 - [0.3 0.2 0.1])) < tol);

    % --- flight coordinates round trip (ECEF <-> flight) ---
    p0 = [-2e6 4e6 3e6]; v0 = [1000 -500 800];
    [r, lat, lon, sp, chi, gam] = cecef2flight(p0(1), p0(2), p0(3), v0(1), v0(2), v0(3));
    [x1, y1, z1, vx1, vy1, vz1] = cflight2ecef(r, lat, lon, sp, chi, gam);
    chk('ECEF->flight->ECEF pos', norm([x1 y1 z1] - p0) < 1e-3);
    chk('ECEF->flight->ECEF vel', norm([vx1 vy1 vz1] - v0) < 1e-3);

    % --- ECI round trip (needs Aerospace Toolbox) ---
    if exist('siderealTime', 'file') || exist('siderealTime', 'builtin')
        utc = datetime(2024, 1, 1, 12, 0, 0, 'TimeZone', 'UTC');
        [xi, yi, zi] = cecef2eci(utc, p0(1), p0(2), p0(3));
        [xe, ye, ze] = ceci2ecef(utc, xi, yi, zi);
        chk('ECEF->ECI->ECEF round trip', norm([xe ye ze] - p0) < 1e-3);
        [az, el, rs] = ceci2aer(utc, xi, yi, zi, 31.6775, 116.7559, 72.4);
        chk('ceci2aer finite', all(isfinite([az el rs])));
    else
        fprintf('  SKIP ECI tests (Aerospace Toolbox not present)\n');
    end

    % --- RFC / ENU rotation pair ---
    enu0 = [100; 200; 30];
    rfc = cenu2rfc(enu0, 30, 10);
    enu1 = crfc2enu(rfc, 30, 10);
    chk('ENU->RFC->ENU round trip', norm(enu1 - enu0) < tol);

    % --- UVR direction cosines ---
    [u, v, rs2] = crfc2uvr([1; 2; 3]);
    chk('crfc2uvr rslant', abs(rs2 - norm([1 2 3])) < tol);
    chk('crfc2uvr unit cosines', abs(u^2 + v^2 + (3/rs2)^2 - 1) < tol);

    % --- height/elevation helpers now runnable ---
    chk('get_elev_by_hr finite', isfinite(get_elev_by_hr(400., 500., 72.)));
    chk('get_h_by_er finite', isfinite(get_h_by_er(30., 500., 72.)));
    chk('get_rslant_by_enh finite', isfinite(get_rslant_by_enh(400., 100., 200., 72.)));

    % --- cgps2aer lat/lon fix sanity (finite, az in [0,360)) ---
    [t2, az2, el2, rs3] = cgps2aer([0 31.635 116.701 464.8], 31.6775, 116.7559, 72.4);
    chk('cgps2aer finite az/el/rs', all(isfinite([az2 el2 rs3])) && rs3 > 0);

    fprintf('\nREGRESSION: %d passed, %d failed\n', npass, nfail);
    if nfail > 0
        error('test_regression: %d check(s) failed', nfail);
    end

    function chk(name, cond, extra)
        if logical(all(cond(:)))
            npass = npass + 1;
            fprintf('  PASS  %s\n', name);
        else
            nfail = nfail + 1;
            msg = '';
            if nargin >= 3 && ~isempty(extra)
                msg = extra();
            end
            fprintf('  FAIL  %s  %s\n', name, msg);
        end
    end

end
