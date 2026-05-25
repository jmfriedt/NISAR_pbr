from skyfield.api import load, wgs84, EarthSatellite
from skyfield.framelib import itrs

import numpy as np

eph = load('de421.bsp')
LocationC= wgs84.latlon(47.2514446234477,5.99423112464455)                      # Receiver (Besancon, France)
LocationA= wgs84.latlon(47.2514100993763,5.99555087627152)   
LocationB= wgs84.latlon(47.2523432298483,5.99428181905344)   
LocationD= wgs84.latlon(47.2523087046979,5.99560159294324)   
diffAC=LocationA-LocationC
diffBC=LocationB-LocationC
diffDC=LocationD-LocationC

ts = load.timescale()  # Create a Skyfield timescale object for specifying times
ti = ts.utc(2026, 3, 13) # Specify year, month, day to start our search

print(ti.utc_strftime('%Y %b %d %H:%M:%S'))
print(diffAC.at(ti).frame_xyz(LocationC).m)
print(diffAC.at(ti+1/24).frame_xyz(LocationC).m)
print(diffAC.at(ti+1/24).frame_xyz(itrs).m)
print(diffBC.at(ti).frame_xyz(LocationC).m)
print(diffBC.at(ti+1/24).frame_xyz(LocationC).m)
print(diffBC.at(ti+1/24).frame_xyz(itrs).m)
print(diffDC.at(ti).frame_xyz(LocationC).m)
print(diffDC.at(ti+1/24).frame_xyz(LocationC).m)
print(diffDC.at(ti+1/24).frame_xyz(itrs).m)
