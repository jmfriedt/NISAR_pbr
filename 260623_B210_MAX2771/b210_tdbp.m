Nr= 2501;   % from range compression: number of range positions
P = 2501;   % from range compression: number of satellite positions
b210tdbp=1;
dX=10  % resolution (m)
dY=10
hasdem=0;  % 1
meanalti=0 % 348.1; % mean(mean(dem))
addpath('../octave');
tdbp
figure
imagesc(Xl,Yl,dem)
axis xy
colorbar
