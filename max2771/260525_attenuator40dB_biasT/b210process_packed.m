pkg load signal
fs=24e6;
% f=fopen('12.bin');
f=fopen('cut.bin');
N=fs/100;
bit2val=[1,3,-1,-3];

x=fread(f,N,'uint8');
i0=bit2val(bitand(x,3)+1);
q0=bit2val(bitand(bitshift(x,-2),3)+1);
i1=bit2val(bitand(bitshift(x,-4),3)+1);
q1=bit2val(bitand(bitshift(x,-6),3)+1);
d1=i0+j*q0;
d2=i1+j*q1;

m=1;

t=[-248:248]/fs;
c=chirp(t,0,t(end),10e6);

while ((length(d2)==N)) %  && (m<17*100))  % -- 10+17=27
   ma1(m)=max(real(d1));
   a1(m)=var(d1);
   x1(m)=max(abs(xcorr(d1))(N+100:N+5000*4));
   ma2(m)=max(real(d2));
   a2(m)=var(d2);
   x2(m)=max(abs(xcorr(d2))(N+100:N+5000*4));
   xx1(m)=max(abs(xcorr(d1,c)));
   xx2(m)=max(abs(xcorr(d2,c)));
   m=m+1;

   x=fread(f,N,'uint8');
   i0=bit2val(bitand(x,3)+1);
   q0=bit2val(bitand(bitshift(x,-2),3)+1);
   i1=bit2val(bitand(bitshift(x,-4),3)+1);
   q1=bit2val(bitand(bitshift(x,-6),3)+1);
   d1=i0+j*q0;
   d2=i1+j*q1;
%   waitbar((m-1)*N*2/dirlist.bytes)
end

if (1==0)
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
end

figure
subplot(211)
plot([0:length(xx1)-1]/fs*N,xx1);axis tight
ylabel('xcorr ch1 (a.u.)')
subplot(212)
plot([0:length(xx2)-1]/fs*N,xx2);axis tight
ylabel('xcorr ch2 (a.u.)')
