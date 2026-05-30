close all
clear all
if exist ('OCTAVE_VERSION')
  pkg load signal
end
load kpos.mat

fs=22e6;
f1=fopen('260314_ref.bin'); % d=fread(f1,inf,'int16'); ref=d(1:2:end)+j*d(2:2:end);
f2=fopen('260314_sur.bin'); % d=fread(f2,inf,'int16'); sur=d(1:2:end)+j*d(2:2:end);

kstart=1000
kend=length(kpos)-1000;

fseek(f1,kpos(kstart)*2*2) % complex short
fseek(f2,kpos(kstart)*2*2) % complex short

x=zeros(4*Npuls+1,kend-kstart+1); % 2*Npuls=18 km*2=36 km !
for m=kstart:kend
   ref=fread(f1,(kpos(m+1)-kpos(m))*2,'int16');ref=ref(1:2:end)+j*ref(2:2:end);
   sur=fread(f2,(kpos(m+1)-kpos(m))*2,'int16');sur=sur(1:2:end)+j*sur(2:2:end);
%   ref=ref-mean(ref);
%   sur=sur-mean(sur);
   x(:,m-kstart+1)=(xcorr(ref,sur,2*Npuls)); 
%      subplot(311);plot(real(ref));
%      subplot(312);plot(real(sur));
%      subplot(313);plot(abs(x(:,m-kstart+1)));
%      pause
   waitbar((m-kstart)/(kend-kstart))
end

Nifft=512;
tkpos=kpos(kstart:kend)/fs;
fifft=linspace(-200,200,Nifft);
fftmat=exp(j*2*pi*tkpos'*fifft);
y=x*fftmat;
imagesc([0:size(y)(2)-1],([0:size(y)(1)]-size(y)(1)/2)/fs*300*1e6,abs(y))
%caxis([0 1e7])
%ylim([-20000 1000])
