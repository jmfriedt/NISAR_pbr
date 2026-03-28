clc;
clear;
close all;

load kpos

%% Parameters
c = 3e8;
fc = 1229e6; % c/lembda;
lembda = c/fc; % 24e-2;

H = 750.2e3;       % TLE Celestrak (semi-major axis)
theta0 = 44*pi/180;
beta_sat = -H/sin(theta0);

fs = 24e6;

Nr = 2501;
freq = (-(Nr-1)/2:(Nr-1)/2).'/Nr*fs;

orbits_per_day=14.42502395
orbit_duration=24*3600/orbits_per_day; % second
Rearth=6371*1e3;                       % meters
orbit_length=(Rearth+H)*2*pi;

linspeed=orbit_length/orbit_duration
% linspeed = sqrt(5.972e24*6.67430e-11/(6371e3+H)) % sqrt((G*M)/(R+H)) gravity constant x Earth mass
P = 3501;

%% Load data
f1=fopen('2.bin');  % ref
f2=fopen('1.bin');  % sur
clear d

%% Find pulses
% p1 = find(abs(ref1)>70);
% p2 = p1(1);
% pindx = p2;
% do_search = 1;
% while do_search
%     ref2 = ref1(p2+200:end);
%     p1 = find(abs(ref2)>70)+p2+200-1;
%     if ~isempty(p1)
%         p2 = p1(1);
%         pindx = [pindx;p2]; %#ok<AGROW>
%     else
%         do_search = 0;
%     end
% end
%pindx=kpos(1000:end-1000);

%% Raw data
 Sref = zeros(Nr,P);
 Ssur = zeros(Nr,P);
 L = 5;
 AS = 50;

pindx=kpos(9000:9000+P+L);

 fseek(f1,2*pindx(1)-AS-1-L);  % complex char = 2x2
 fseek(f2,2*pindx(1)-AS-1-L);  % complex char = 2x2
 d=fread(f1,(pindx(end)-pindx(1)+Nr+L)*2,'int8');ref1=d(1:2:end)-j*d(2:2:end);
 d=fread(f2,(pindx(end)-pindx(1)+Nr+L)*2,'int8');sur1=d(1:2:end)-j*d(2:2:end);
 pindx=pindx-(pindx(1)-AS)+1+L;
 clear d

 for p = 1:P
     disp(p);
     Sref(:,p) = ref1(pindx(p)-AS:pindx(p)-AS+Nr-1);
     Sls = zeros(Nr,L);
     for l = -(L-1)/2:(L-1)/2
         Sls(:,l+(L-1)/2+1) = ref1(pindx(p)-AS+l:pindx(p)-AS+Nr-1+l);
     end
     temp = sur1(pindx(p)-AS:pindx(p)-AS+Nr-1);
     Ssur(:,p) = temp-Sls*pinv(Sls)*temp;
 end
 N = length(ref1);
 t = (0:N-1)/fs;
 t1 = t(1:end);

 t0 = t1(round(pindx(1:end-3))-round(AS)).';t0 = t0(1:P);
 t0 = t0-(t0(1)+t0(end))/2;
% load t0.mat t0;

 Sref_fft = zeros(Nr,P);
 Ssur_fft = zeros(Nr,P);
 S = zeros(Nr,P);
 for p = 1:P
     Sref_fft(:,p) = fftshift(fft(Sref(:,p)-mean(Sref(:,p))));
     Ssur_fft(:,p) = fftshift(fft(Ssur(:,p)-mean(Ssur(:,p))));
     S(:,p) = Ssur_fft(:,p).*conj(Sref_fft(:,p));
 end

%load S.mat S;

%% SAR imaging
al_sat = linspeed*t0;

beta_I = linspace(0,25000,2501);nbe = length(beta_I);
F1 = exp(-1j*2*pi*freq*beta_I/c)/sqrt(Nr);

al_I = linspace(-5e-3,5e-3,2001);nal = length(al_I);
F2 = exp(-1j*2*pi*al_sat*al_I/lembda)/sqrt(P);

Image_I = F1'*S*conj(F2);
Image_I_db = 10*log10(abs(Image_I)/max(abs(Image_I(:))));
figure;imagesc(al_I,beta_I,Image_I_db);axis xy;
colormap(jet);colorbar;clim([-30,0]);
xlabel('\alpha_{\itI}');ylabel('\beta_{\itI} (m)');
ylabel(colorbar,'Normalized amplitude (dB)');
%set(gca,'FontName','Times New Roman','FontSize',14);

%% Image on x-o-y plane
xm = linspace(0,10e3,2001);nxm = length(xm);
ym = linspace(-4000,4000,2001);nym = length(ym);

[X,Y] = meshgrid(xm,ym.');A = Y;

tmpA = Y.^2;
tmpB = H/sin(theta0);
tmpC = sqrt((H*cot(theta0)+X).^2+Y.^2+H^2)+sqrt(X.^2+Y.^2);
B1 = -sqrt(4*tmpA.*tmpB.^2.*tmpC.^2-4*tmpA.*tmpC.^4+tmpB.^4.*tmpC.^2-2*tmpB.^2.*tmpC.^4+tmpC.^6)-tmpB.^3+tmpB.*tmpC.^2;
B2 = 2*(tmpB.^2-tmpC.^2);
B = B1./B2;

[al_I_grid,beta_I_grid] = meshgrid(al_I,beta_I.');
al_grid = A./(beta_sat-B);
beta_grid = sqrt(A.^2+B.^2)+B-A.^2./(beta_sat-B)/2;

Image_xy = interp2(al_I_grid,beta_I_grid,Image_I,al_grid,beta_grid,'linear',0);
Image_xy_db = 10*log10(abs(Image_xy)/max(abs(Image_xy(:))));
figure;imagesc(ym,xm,Image_xy_db.');axis xy;
clim([-30,0]);colormap(jet);colorbar;
xlabel('x (m)');ylabel('y (m)');
ylabel(colorbar,'Normalized amplitude (dB)');
%set(gca,'FontName','Times New Roman','FontSize',14);
