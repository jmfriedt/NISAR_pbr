pkg load signal
fs=22e6;
if (exist('filename1')==0) filename1='1.bin';end
if (exist('filename2')==0) filename2='2.bin';end

f1=fopen(filename1); % 1ref
f2=fopen(filename2); % 2sur
N=fs/100;
d=fread(f1,2*N,'int16');d1=d(1:2:end)+j*d(2:2:end);
d=fread(f2,2*N,'int16');d2=d(1:2:end)+j*d(2:2:end);
m=1;

t=[-218:218]/fs;
c=chirp(t,0,t(end),10e6);

while ((length(d1)==N)) %  && (m<17*100))  % -- 10+17=27
   ma1(m)=max(real(d1));
   a1(m)=var(d1);
   x1(m)=max(abs(xcorr(d1))(N+100:N+5000*4));
   ma2(m)=max(real(d2));
   a2(m)=var(d2);
   x2(m)=max(abs(xcorr(d2))(N+100:N+5000*4));
   xx1(m)=max(abs(xcorr(d1,c)));
   xx2(m)=max(abs(xcorr(d2,c)));
   d=fread(f1,2*N,'int16');d1=d(1:2:end)+j*d(2:2:end);
   d=fread(f2,2*N,'int16');d2=d(1:2:end)+j*d(2:2:end);
   m=m+1;
end
figure
subplot(311)
plot([0:length(a1)-1]/fs*N,a1);axis tight
ylabel('power (a.u.)')
subplot(312)
plot([0:length(x1)-1]/fs*N,x1);axis tight
ylabel('autocorrelation (a.u.)')
subplot(313)
plot([0:length(x1)-1]/fs*N,ma1);axis tight
ylabel('max I (a.u.)')
xlabel('time (s)')

figure
subplot(311)
plot([0:length(a2)-1]/fs*N,a2);axis tight
ylabel('power (a.u.)')
subplot(312)
plot([0:length(x2)-1]/fs*N,x2);axis tight
ylabel('autocorrelation (a.u.)')
subplot(313)
plot([0:length(x2)-1]/fs*N,ma2);axis tight
ylabel('max I (a.u.)')
xlabel('time (s)')

figure
subplot(211)
plot([0:length(xx1)-1]/fs*N,xx1);axis tight
ylabel('xcorr ch1 (a.u.)')
subplot(212)
plot([0:length(xx2)-1]/fs*N,xx2);axis tight
ylabel('xcorr ch2 (a.u.)')
