from skyfield.api import load, wgs84, EarthSatellite
from skyfield.framelib import itrs

import numpy as np

eph = load('de421.bsp')
Location = wgs84.latlon(47.5526311490814, -2.58462077045721) # Satellite
LocationC= wgs84.latlon(47.2469,5.9897)                      # Receiver (Besancon, France)

# NISAR TLE downloaded May. 31, 2026 from http://www.celestrak.org/NORAD/elements/gp.php?CATNR=65053
sat = EarthSatellite("1 65053U 25163A   26151.17081919  .00000326  00000-0  11144-3 0  9992",
                     "2 65053  98.4051 339.0845 0001217  90.8886 269.2443 14.42506472 43934")
sat = EarthSatellite("1 65053U 25163A   26162.96271956  .00000214  00000-0  77591-4 0  9998",
                     "2 65053  98.4052 350.7040 0001219  89.0153 271.1176 14.42505658 45630")
sat = EarthSatellite("1 65053U 25163A   26169.06675806  .00000101  00000-0  43624-4 0  9993",
                     "2 65053  98.4054 356.7188 0001210  89.5751 270.5578 14.42506467 46517")

print(f"% {sat}")             # Confirms TLE was loaded successfully
ts = load.timescale()  # Create a Skyfield timescale object for specifying times
ti = ts.utc(2026, 6, 23, 18, 42, 49.58925351818181) # Specify year, month, day to start our search
difference = sat - LocationC
print('% '+ti.utc_strftime('%Y %b %d %H:%M:%S'))
t=np.genfromtxt("tpos.txt")   # time of each pulse since 20:48.80345523672727
for k in range(len(t)):
  # print((ti+t[k]/3600/24).utc_strftime('%Y %b %d %H:%M:%S'))
  print(difference.at(ti+t[k]/3600/24).frame_xyz(LocationC).m)
