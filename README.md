# Coordinate Transformation Toolbox - Aerospace Extension

## Software requirements

- MATLAB > R2019a

> Some machines may not be able to display UTF-8 characters due to backward configuration. Please use an advanced editor to open and view the original file.

## Design Principle

This toolbox is designed based on the MATLAB `Mapping` toolbox. By ensuring high similarity and readability with the official API, it reduces the learning cost for users and the testing cost for developers.

Its main design principles are as follows

- Function names adopt name pattern in the `Mapping` toolbox, while
  - add prefix `c` to the coordiate transformation function
  - add prefix `q` to the quaternion function
  - add prefix `u` to the unit conversion function
  - add prefix `get_` to the calculation function
- Input includes parameter type verification
- Output dimension flexibility
- Use MATLAB builtin functions wherever possible
- Reference ellipsoid model is written in object-oriented form to facilitate subsequent expansion
- Encoding only uses UTF-8

## Dependencies

This is the aerospace extension layer and is not self-contained. It relies on:

- `matlab-geodesy` (the sibling toolbox), which must be on the path. Used symbols:
  `refEllipsoid`, `cgeodetic2ecef`, `cecef2geodetic`, `cecef2enu`, `cecef2enuv`,
  `cenu2ecefv`, `cenu2aer`, `caer2ecef`, `cen2ar`.
- MATLAB Aerospace Toolbox for the Earth-centered inertial transforms
  (`cecef2eci`, `ceci2ecef`, `caer2eci`, `ceci2aer`), which call `siderealTime` and
  `juliandate`.

## Known limitations

A small number of functions are not yet functional. Each affected file carries a
header `WARNING` banner; do not rely on them until repaired against the original
reference.

- Launch / velocity orientation stubs — throw at runtime because they call the
  undefined helpers `unedv2euler` / `rlaunch2vel` and use an undefined `dt`:
  `claunch2body`, `claunch2vel`, `cvel2launch`.
- Antenna / platform / RFC spherical projection family — the `M` projection is
  incorrect: `cant2rfc` and `cant2platform` throw a matrix-dimension error, while
  `crfc2ant` and `cplatform2ant` run but silently return wrong (occasionally complex) results.

![schema](docs/geodesyx.drawio.png)

> Dotted line in the schematic diagram indicates indirect transformation, which may cause cumulative errors
