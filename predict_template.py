from skyfield.api import load, wgs84, EarthSatellite

eph = load('de421.bsp')
Location = wgs84.latlon(LAT, LON)
LocationC= wgs84.latlon(LATC,LONC)

# NISAR TLE downloaded Dec. 28, 2025 from http://www.celestrak.org/NORAD/elements/gp.php?CATNR=65053
sat = EarthSatellite("1 65053U 25163A   26032.97429835  .00000050  00000+0  28117-4 0  9993",
                     "2 65053  98.4066 222.5889 0001230  89.3026 270.8305 14.42502395 26899")

print(sat)  # Confirms TLE was loaded successfully

ts = load.timescale()  # Create a Skyfield timescale object for specifying times

search_start = ts.utc(2026, 1, 11) # Specify year, month, day to start our search
search_end = ts.utc(2026, 2, 20) # Search for passes until Year, month, day.

# This next section summarizes the informatino and provides the max elevation of the pass
t, events = sat.find_events(Location, search_start, search_end, altitude_degrees=80.0)
for ti, event in zip(t, events):
    name = ('rise above 80°', 'culminate', 'set below 80°')[event]
    if name == "culminate":
        tculm = ti
        tculmp30 = ti +3.4e-5 # 30"
        difference = sat - LocationC
        topocentric = difference.at(tculm)
        topocentricp30 = difference.at(tculmp30)
        alt, az, distance = topocentric.altaz()
        altp30, azp30, distancep30 = topocentricp30.altaz()
        daz=azp30.degrees-az.degrees
        if az.degrees<180:  # east: az from 0 to 180 when descending 
            daz=-daz        # west: 180 to 360 when ascending

        print(ti.utc_strftime('%Y %b %d %H:%M:%S'), end=" ")
        print(f"max elevation {alt} at {az}", end=" ")
        if (daz>0):
            print("ascending")
        else:
            print("descending")
