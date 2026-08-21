from skyfield.api import load, wgs84, EarthSatellite
# for CSV formatted datasets
from io import StringIO 
import csv

eph = load('de421.bsp')
Location = wgs84.latlon(LAT, LON)
LocationC= wgs84.latlon(LATC,LONC)

ts = load.timescale()  # Create a Skyfield timescale object for specifying times
# Skyfield header (for CSV formatted datasets)
header = ("OBJECT_NAME,OBJECT_ID,EPOCH,MEAN_MOTION,ECCENTRICITY,INCLINATION,RA_OF_ASC_NODE,ARG_OF_PERICENTER,MEAN_ANOMALY,EPHEMERIS_TYPE,CLASSIFICATION_TYPE,NORAD_CAT_ID,ELEMENT_SET_NO,REV_AT_EPOCH,BSTAR,MEAN_MOTION_DOT,MEAN_MOTION_DDOT")

# NISAR TLE downloaded Dec. 28, 2025 from http://www.celestrak.org/NORAD/elements/gp.php?CATNR=65053
#sat = EarthSatellite("1 65053U 25163A   26032.97429835  .00000050  00000+0  28117-4 0  9993",
#                     "2 65053  98.4066 222.5889 0001230  89.3026 270.8305 14.42502395 26899")
#sat = EarthSatellite("1 65053U 25163A   26103.24020753 -.00000172  00000+0 -38688-4 0  9999",
#                     "2 65053  98.4061 291.8505 0001176  89.9097 270.2227 14.42503010 37020")
#sat = EarthSatellite("1 65053U 25163A   26151.17081919  .00000326  00000-0  11144-3 0  9992",
#                     "2 65053  98.4051 339.0845 0001217  90.8886 269.2443 14.42506472 43934")
#sat = EarthSatellite("1 65053U 25163A   26169.06675806  .00000101  00000-0  43624-4 0  9993",
#                     "2 65053  98.4054 356.7188 0001210  89.5751 270.5578 14.42506467 46517")
#sat = EarthSatellite("1 65053U 25163A   26177.25172557  .00000333  00000-0  11375-3 0  9992",
#                     "2 65053  98.4055   4.7842 0001220  88.7028 271.4302 14.42506001 47693")
#sat = EarthSatellite("1 65053U 25163A   26191.74882693  .00000145  00000-0  56990-4 0  9995",
#                     "2 65053  98.4056  19.0698 0001229  89.8839 270.2492 14.42505464 49784")

newceletrak="NISAR,2025-163A,2026-08-20T22:49:36.533856,14.42504759,.00012433,98.4058,59.6734,89.8144,270.3188,0,U,65053,999,5572,.25347201E-4,.41E-6,0"
f = StringIO(header+"\n"+newceletrak)
fields=next(csv.DictReader(f))
sat = EarthSatellite.from_omm(ts, fields)

print(sat)  # Confirms TLE was loaded successfully

search_start = ts.utc(2026, 8, 21) # Specify year, month, day to start our search
search_end = ts.utc(2026, 9, 22) # Search for passes until Year, month, day.

# This next section summarizes the information and provides the max elevation of the pass
t, events = sat.find_events(Location, search_start, search_end, altitude_degrees=80.0)
for ti, event in zip(t, events):
    name = ('rise above 80°', 'culminate', 'set below 80°')[event]
    if name == "culminate":
        tculm = ti
        csearch_start = tculm-1/24
        csearch_end = tculm+1/24
        ct, cevents = sat.find_events(LocationC, csearch_start, csearch_end, altitude_degrees=40.0)
        for cti, cevent in zip(ct, cevents):
            cname = ('rise above 80°', 'culminate', 'set below 80°')[cevent]
            if cname == "culminate":
                print(cti.utc_strftime('%Y %b %d %H:%M:%S'),end=" ")
                ctculmp30 = cti +3.4e-5 # 30"
                difference = sat - LocationC
                topocentric = difference.at(cti)
                topocentricp30 = difference.at(ctculmp30)
                alt, az, distance = topocentric.altaz()
                altp30, azp30, distancep30 = topocentricp30.altaz()
                daz=azp30.degrees-az.degrees
                if az.degrees<180:  # east: az from 0 to 180 when descending
                    daz=-daz        # west: 180 to 360 when ascending
                print(f"max elevation {alt} at {az}", end=" ")
                if (daz>0):
                    print("ascending")
                else:
                    print("descending")
