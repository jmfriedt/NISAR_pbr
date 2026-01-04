# Passive Bistatic RADAR using the spaceborne L and S-band NISAR satellite signal

A. Witze, *Arctic scientists iced out by radar mission*, Nature **566** (7 Feb. 2019): "Most other SAR missions are right-looking 
[... but...] NISAR science team decided to make its satellite **left-looking** for its entire primary mission."
confirmed by https://science.nasa.gov/mission/nisar/observation-strategy/: "As NISAR will be only **left-looking** -- a change in 
observation tactics since the early planning stages -- the mission will rely on data from the international constellation of 
SAR satellites to supplement its coverage around the Arctic pole" (last updated Jul 23, 2025).

Funny enough, this <a href="https://science.nasa.gov/video-detail/amf-1a1ed0e7-59b4-4a9d-acc5-d52896620f2b/">video</a> from the NASA
web site still shows the spaceborne RADAR shooting to the right, as does <a href="https://www.isro.gov.in/media_isro/image/index/NISAR/Picture3.jpg.webp">this picture</a> from ISRO.

## Need to know when to listen

From the TLE orbital parameters, the known satellite altitude and the known 
RADAR look angle (angle between antenna pointing and nadir) we can predict when
NISAR will be illuminating a given location. **Script update (Dec. 24, 2025): following
the failure to record a signal, I discovered that NISAR is left looking, not right-looking
like Sentinel-1. The S1 and NISAR scripts hence differ beyond altitude and orbital parameter
tuning.**

<img src="figures/angles.png">

Furthermore, the script assumes a mean illumination angle of 40 degrees, when https://bhoonidhi.nrsc.gov.in/NISAR/
indicates a mean angle of 37 degrees.

* ``go.sh``: main script, includes the location of the ground station. Requires GDAL to
convert from spherical (WGS84) to projected (UTM32N for France) and back.
* ``go.m``: GNU/Octave script for computing the projected RADAR beam on the ground
* ``nisar_tle*.txt``: orbital parameters of the satellite, to be updated from <a href="http://www.celestrak.org/NORAD/elements/gp.php?CATNR=65053">Celestrak</a> every
month or so. These entries are used to plot the ground tracks in QGIS and copied into
the following Python template script.
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
matching nicely the two top passes after 12 days (20251217 between 17:32:06 and 17.32:33 matches 20251229 at 17:32:11 and 20251216 between 05:43:30 and 05:43:57 matches 20251228 at 05:43:32)

but
```
LEFT
2025 Dec 22 17:40:20 culminate
2025 Dec 27 06:41:19 culminate          <- remove left morning pass
 
RIGHT:
2025 Dec 23 05:35:25 culminate
2025 Dec 25 16:26:30 culminate          <- remove right evening pass
2025 Dec 30 16:34:36 culminate          <- remove right evening pass
```
leaves two unidentified predicted passes which do not occur (would have been
Dec. 10 and 11 according to the 12 day repeat). On the other hand, observations during
Dec. 9 and 12 leading to 21 and 24 are not predicted from the orbital parameters.

Looking at the trajectory in QGIs:

<img src="besac_s1a.png"> 

the green tracks match illumination of the receiver site, and the red ones do not (beaming in the wrong direction).

## Illumination prediction for NISAR

From this analysis, NISAR is expected to illuminate Paris on

```
2025 Dec 27 18:59:33 UTC
2025 Dec 28 04:36:37 UTC
2026 Jan 03 19:07:45 UTC
```

with the Dec. 27 pass slightly off angle at 81 degrees instead of max. 83 degrees since 40+/-7 
translates to 90+/-7 >= 83 at azimuth. The beamwidth is $\lambda/D$ with $\lambda\simeq 300/1250=24$ cm at
L-band and $D=12$ m leading to a beamwidth (-3 dB) of 1.1 degrees.

The ground projected tracks are generated using ``gtg``:

<img src="251227/paris_nisar.png">

All ground tracks were plotted using <a href="https://github.com/anoved/Ground-Track-Generator">Ground
Track Generator</a> with the command 
```
gtg --input nisar_tle.txt --output 251227 --start "2025-12-27 18:59:00.0 UTC" --end "2025-12-27 19:05:00.0 UTC" --interval 5s
```
or to get all output parameters
```
gtg --input nisar_tle.txt --output 241527 --start "2025-12-27 18:59:00.0 UTC" --end "2025-12-24 19:05:00.0 UTC" --interval 5s --attributes all --observer 48.87337 2.24588
```

We can convince that the Dec. 27, 2025 at 18h49 UTC pass is decending by extending the simulation duration and
seeing NISAR fly southward (dark green dots). The reds paths are again excluded from the analysis since the beam
is illuminating in the wrong direction (ascending West and descending East).

## Frequency settings

NISAR <a href="https://www.eoportal.org/ftp/satellite-missions/n/NISAR-25032021/NISAR.html">broadcasts</a>
at 1257.5+/-20 MHz and 3200+/-37.5 MHz. The L-band is within the reach of the lower L2/L5 band of the 
MAX2771 (1160-1290 MHz). GNSS SDR receivers and <a href="https://www.ardusimple.com/product/antenna-for-gnss-multiband-oem/">L2-GPS/E6-Galileo multiband antennas</a> are well suited for
the reception.

P.A. Rosen & al, *The NASA-ISRO SAR Mission -- A summary*, IEEE Geoscience and Remote Sensing Mag. (June 2025) 
shows in Fig. 16 that all frequency plans *start* at the same frequency, namely
**1221.5 MHz**, with a split emission at the beginning of the band (20 MHz wide) and end to assess ionospheric
contribution, to the delay:

<img src="figures/NISAR_frequency_plan.png">

## December 27, 2025 illumination of Paris (France)

Based on this analysis, NISAR is predicted to illuminate Paris (France) on Dec. 27, 2025, at 19:59 local time. A
10 minute recording from 19:54 to 20:04 local time at 6 MS/s was collected using a B210 fitted with a bias-T and a 
dual L-band GNSS antenna. From Heavens Above:

<img src="251227/251227PassSkyChart2.png">

<img src="251227/251227schedule.png">

the satellite illuminates from the West (descending pass since beaming leftward) at a maximum elevation of 
53 degrees, matching the https://bhoonidhi.nrsc.gov.in/NISAR/ mean illumination angle of 37 degrees (=90-53).

The resulting magnitude (standard deviation as square root of the variance) as a function of time, and 
off-center auto-correlation (the 0-delay autocorrelation is the variance) of the recording:

<img src="251227/nisar_abs_time.png">

The recording was started at 19:54:02.6 according to the ``stat``function applied to the
recorded binary file, and the chirp maximum is observed after 299 s or 19:59:01.6, close enough
to the predicted maximum elevation at 19:59:04.

The time-domain chirp including its duration and repetition interval

<img src="251227/nisar_real_time.png">

and deduced non-constant pulse repetition interval:

<img src="251227/nisar_PRI.png">

Since only 6-MHz bandwidth (limited by the B210 transfer rate, even using the 
<a href="251227/b210_NISAR_recording.py">8-bit Over the Wire</a> format) of
the potentially 20-MHz wide chirp was recorded, the pulse duration cannot be
observed directly. The 5.5 us duration matches a 20 us duration of the 20 MHz 
wide pulse with only a fraction of the bandwidth being recorded.

## January 03, 2026 illumination of Paris (France)

To demonstrate that the previous measurement was not sheer luck, the analysis was repeated
for January 2026: Jan. 03, 2025, at 20:07 local time is predicted to provide a suitable 
condition. A 10 minute recording from 20:02 to 20:12 local time at 6 MS/s was collected using 
a B210 fitted with a bias-T and a dual L-band GNSS antenna, <a href="260103/b210_NISAR.py">this 
time centered on 1223.5 MHz</a> to record more of the 20 MHz-wide chirp. From Heavens Above:

<img src="260103/260103PassSkyChart2.png">

<img src="260103/260103Schedule.png">

the satellite illuminates from the West (descending pass since beaming leftward).

The resulting magnitude (standard deviation as square root of the variance) as a function of time, and 
off-center auto-correlation (the 0-delay autocorrelation is the variance) of the recording:

<img src="260103/nisar_abs_time260103.png">

Recording started at 20:02:31.7 (according to ``stat`` on the resulting binary file) and the
maximum power is recorded after 283 seconds so 20:07:14.7 close enough to the predicted 20:07:16. There
is no need to record a full 10 minute, +/-5 minute around the predicted pass time, but a few tens of
seconds seem enough, saving disk space and processing time. 

The time-domain chirp including its duration and repetition interval

<img src="260103/nisar_real_time260103.png">

and deduced non-constant pulse repetition interval:

<img src="260103/nisar_PRI260103.png">

## Experimental setup

A B210 SDR fitted with a <a href="https://www.ardusimple.com/product/antenna-for-gnss-multiband-oem/">Ardusimple OEM</a> antenna powered through a bias T: the DC supply is
either from a power-pack or a USB port of the laptop. Maximum datarate from B210 to laptop
is 6 MS/s with minimal losses with other-the-wire 8-bit data width.

<img src="IMG_20251222_161622_912.jpg">

First trials only use one of the two antennas, the second one will be added for recording the
surveillance signal.
