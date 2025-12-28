from skyfield.api import load, wgs84, EarthSatellite

eph = load('de421.bsp')
Location = wgs84.latlon(LAT, LON)

# NISAR TLE downloaded Dec. 28, 2025 from http://www.celestrak.org/NORAD/elements/gp.php?CATNR=65053
sat = EarthSatellite("1 65053U 25163A   25362.11300412  .00000381  00000+0  12822-3 0  9995",
                     "2 65053  98.4062 187.2344 0001196  88.3819 271.7508 14.42504229 21728")

print(sat)  # Confirms TLE was loaded successfully

ts = load.timescale()  # Create a Skyfield timescale object for specifying times

search_start = ts.utc(2025, 12, 27) # Specify year, month, day to start our search
search_end = ts.utc(2026, 1, 4) # Search for passes until Year, month, day.

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
