latitude=[0:1:90];
longitude=[0:.1:6];
zone_number=31; % UTM31N
longdiff=longitude-((zone_number-1.0)*6.0-180.0+3.0);
correction=atand(tand(longdiff')*sind(latitude))
imagesc(longitude,latitude,correction')
colorbar
xlabel('longitude within UTM zone (deg.)')
ylabel('latitude (deg)')
title('angle correction (deg) as a function of latitude and longitude error')
hold on
plot(6,47,'ro')
