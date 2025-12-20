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
* ``predict_template.py``: <a href="https://rhodesmill.org/skyfield/">SkyField</a> 
based Python program to predict passes with highest 
elevations and hence listening time. Verified against <a href="https://www.heavens-above.com/">Heavens Above</a> for its excellent prediction
capability.

## Validation of the analysis with Sentinel1-A

The above scripts have been adapted to ESA's Sentinel1-A with ``go_s1a.m`` and ``go_s1a.sh`` and ``predict_s1a_template.py``
to use the orbital parameters and beam angle of this satellite. Futhermore, from <a href="https://browser.dataspace.copernicus.eu/?zoom=8&lat=47.4095&lng=6.08093">
the Copernicus browser</a> we search for Sentinel1-A images and identify for Besan&ccedil;on:

```
S1A_IW_SLC__1SDV_20251217T173206_20251217T173233_062358_07CF5C_1C1F.SAFE
S1A_IW_SLC__1SDV_20251216T054329_20251216T054356_062336_07CE83_0B06.SAFE
S1A_IW_SLC__1SDV_20251212T172400_20251212T172427_062285_07CC84_ED14.SAFE
S1A_IW_SLC__1SDV_20251209T055140_20251209T055207_062234_07CA8A_4D06.SAFE
S1A_IW_SLC__1SDV_20251205T173207_20251205T173234_062183_07C886_4F8A.SAFE
S1A_IW_SLC__1SDV_20251204T054330_20251204T054357_062161_07C7AC_6BCD.SAFE
```
whose filenames encode the date and the time of the illumination. From our analysis, we find

```
LEFT: 2025 Dec 29 17:32:11 culminate    <- left is afternoon pass
The Maximum elevation is 84deg 59' 52.4" 75deg 23' 15.3"
RIGHT: 2025 Dec 28 05:43:32 culminate   <- right is morning pass
The Maximum elevation is 82deg 32' 49.1" 285deg 13' 14.0"
```
matching nicely the two top passes after 12 days (20251217 becomes 20251229 and 20251216 becomes 20251228)

but
```
LEFT
2025 Dec 22 17:40:20 culminate
2025 Dec 27 06:41:19 culminate          <- remove left morning
 
RIGHT:
2025 Dec 23 05:35:25 culminate
2025 Dec 25 16:26:30 culminate          <- remove right evening
2025 Dec 30 16:34:36 culminate          <- remove right evening
```
leaving two unidentified predicted pass which do not occur (would have been
Dec. 10 and 11 according to the 12 day repeat) and on the other hand
Dec. 9 and 12 leading to 21 and 24 are not predicted from the orbital parameters.

Looking at the trajectory in QGIs:

<img src="besac_s1a.png"> 

the green tracks match and the red ones do not (beaming in the wrong direction).

## Illumination prediction for NISAR

From this analysis, NISAR is expected to illuminate Paris on
```
2025 Dec 24 05:42:30 culminate
2025 Dec 26 18:01:18 culminate
```

with the ground projected tracks as follows:

<img src="paris_nisar.png">

