% get latitude/longitude
lon=str2num(argv{1});
lat=str2num(argv{2});

% known altitude
alti=693000; % m
% known radar mean angle
%angle=28   ; % degrees IW1 https://sentiwiki.copernicus.eu/web/s1-mission Angles for Stripmap mode beams
angle=32   ; % degrees IW2 https://sentiwiki.copernicus.eu/web/s1-mission Angles for Stripmap mode beams
%angle=37   ; % degrees https://sentiwiki.copernicus.eu/web/s1-mission Angles for Stripmap mode beams
% known polar orbit
ang=8.18    ; % degrees
hei=lat-alti*tand(angle)*sind(ang);
lef=lon-alti*tand(angle)*cosd(ang);
rig=lon+alti*tand(angle)*cosd(ang);
printf("%f %f %f\n",hei,lef,rig)
