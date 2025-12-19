# Passive Bistatic RADAR using the spaceborne L and S-band NISAR satellite signal

## Need to know when to listen

From the TLE orbital parameters, the known satellite altitude and the known 
RADAR look angle (angle between antenna pointing and nadir) we can predict when
NISAR will be illuminating a given location.

* ``go.sh``: main script, includes the location of the ground station. Requires GDAL to
convert from spherical (WGS84) to projected (UTM32N for France) and back.
* ``go.m``: GNU/Octave script for computing the projected RADAR beam on the ground
* ``nisar_tle.txt``: orbital parameters of the satellite, to be updated from Celestrak every
month or so
* ``predict_template.py``: SkyField based Python program to predict passes with highest 
elevations and hence listening time. Verified against Heavens Above for its excellent prediction
capability.

TODO: check (Sentinel-1) that beam reception is at maximum elevation
