from skyfield.api import load, wgs84, EarthSatellite
from skyfield.framelib import itrs
from io import StringIO 
import csv

import numpy as np
header = ("OBJECT_NAME,OBJECT_ID,EPOCH,MEAN_MOTION,ECCENTRICITY,INCLINATION,RA_OF_ASC_NODE,ARG_OF_PERICENTER,MEAN_ANOMALY,EPHEMERIS_TYPE,CLASSIFICATION_TYPE,NORAD_CAT_ID,ELEMENT_SET_NO,REV_AT_EPOCH,BSTAR,MEAN_MOTION_DOT,MEAN_MOTION_DDOT")

eph = load('de421.bsp')
LocationC= wgs84.latlon(47.2469,5.9897)                      # Receiver (Besancon, France)
ts = load.timescale()                               # Skyfield timescale object

# NISAR TLE downloaded May. 31, 2026 from http://www.celestrak.org/NORAD/elements/gp.php?CATNR=65053
sat = EarthSatellite("1 65053U 25163A   26151.17081919  .00000326  00000-0  11144-3 0  9992",
                     "2 65053  98.4051 339.0845 0001217  90.8886 269.2443 14.42506472 43934")
sat = EarthSatellite("1 65053U 25163A   26162.96271956  .00000214  00000-0  77591-4 0  9998",
                     "2 65053  98.4052 350.7040 0001219  89.0153 271.1176 14.42505658 45630")
sat = EarthSatellite("1 65053U 25163A   26169.06675806  .00000101  00000-0  43624-4 0  9993",
                     "2 65053  98.4054 356.7188 0001210  89.5751 270.5578 14.42506467 46517")
sat = EarthSatellite("1 65053U 25163A   26191.74882693  .00000145  00000-0  56990-4 0  9995",
                     "2 65053  98.4056  19.0698 0001229  89.8839 270.2492 14.42505464 49784")

newceletrak="NISAR,2025-163A,2026-08-20T22:49:36.533856,14.42504759,.00012433,98.4058,59.6734,89.8144,270.3188,0,U,65053,999,5572,.25347201E-4,.41E-6,0"
f = StringIO(header+"\n"+newceletrak)
fields=next(csv.DictReader(f))
sat = EarthSatellite.from_omm(ts, fields)

print(f"% {sat}")                                   # Confirms TLE was loaded successfully
ti = ts.utc(2026, 8, 17, 18, 50, 55.945)            # from the file recording time (stat)
difference = sat-LocationC                          #    ... + offset to 1st pulse
print('% '+ti.utc_strftime('%Y %b %d %H:%M:%S'))
t=np.genfromtxt("tpos.txt")                         # time of each pulse since 20:48.80345523672727
for k in range(len(t)):
  # print((ti+t[k]/3600/24).utc_strftime('%Y %b %d %H:%M:%S'))
  print(difference.at(ti+t[k]/3600/24).frame_xyz(LocationC).m)

# File birth = 20:50:45.260392059 + 7" removed + kpos(7005)/22e6=3.6685 = 20:50:55.945
# load b210_kpos.mat 
# tpos=kpos(7005:end)-kpos(7005);
# tpos=tpos'/22e6;
# save -text tpos.txt tpos

# -17.3 -7" + 24 = -0.3" diff
