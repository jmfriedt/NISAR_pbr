from skyfield.api import load, wgs84, EarthSatellite

eph = load('de421.bsp')
Location = wgs84.latlon(LAT, LON)

sat = EarthSatellite("1 39634U 14016A   25353.98471538  .00000000  00000+0  96989-5 0  9995",
                     "2 39634  98.1796 359.1193 0001254  85.4707 274.6636 14.59201682623880")

print(sat)  # Confirms TLE was loaded successfully

ts = load.timescale()  # Create a Skyfield timescale object for specifying times

search_start = ts.utc(2025, 12, 20) # Specify year, month, day to start our search

search_end = ts.utc(2025, 12, 31) # Search for passes until Year, month, day.

t, events = sat.find_events(Location, search_start, search_end, altitude_degrees=80.0)

#for ti, event in zip(t, events):
#    name = ('rise above 80°', 'culminate', 'set below 80°')[event]
#    if event == 1: # Rise above 30 degrees
#        print(ti.utc_strftime('%Y %b %d %H:%M:%S'), name) # Date and time of event [UTC time]
#        print((sat - Location).at(ti).altaz())
#        print("Is the satellite sunlit?: ", sat.at(ti).is_sunlit(eph), "\n") # at time, is it sunlit?
#        print((sat - Location).at(ti).altaz()) # at time, give us the altitude-azimuth

# These 3 lines will, for each pass, give us an indication of the pass's
# quality. We'll print the location of the highest point the satellite reaches 
# in the sky, and we'll print whether the satellite is illuminated.

# This next section summarizes the informatino and provides the max elevation of the pass
t, events = sat.find_events(Location, search_start, search_end, altitude_degrees=80.0)
for ti, event in zip(t, events):
    name = ('rise above 80°', 'culminate', 'set below 80°')[event]
    if name == "culminate":
        tculm = ti
        difference = sat - Location
        topocentric = difference.at(tculm)
        alt, az, distance = topocentric.altaz()
        print(ti.utc_strftime('%Y %b %d %H:%M:%S'), name)
        print("The Maximum elevation is", alt, az)

# (46.3439°N, 14.1306°E): descending pass @ 17:45
#                         ascending pass @ 04:27
# (44.9295°N, 1.9706°W): descending pass @ 18:35
#                        ascending pass @ 05:41
