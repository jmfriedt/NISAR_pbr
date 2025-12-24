% get latitude/longitude
lon=str2num(argv{1});
lat=str2num(argv{2});

% known altitude
alti=750000; % m
% known radar mean angle
angle=40   ; % degrees
% known polar orbit
ang=8.4    ; % degrees
hei=lat+alti*tand(angle)*sind(ang);  % /!\ LEFT looking !
lef=lon-alti*tand(angle)*cosd(ang);
rig=lon+alti*tand(angle)*cosd(ang);
printf("%f %f %f\n",hei,lef,rig)
