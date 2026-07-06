if exist ('OCTAVE_VERSION')
  pkg load signal
end

threshold=5
bit2val=[1,3,-1,-3];
fs=24e6;
N=fs/4;
f=fopen('max2771_12.bin');

fseek(f,fs*27);
x=fread(f,N,'uint8');       % /!\ MUST be unsigned, otherwise the sign of Q1 is lost
i0=bit2val(bitand(x,3)+1);
q0=bit2val(bitand(bitshift(x,-2),3)+1);
i1=bit2val(bitand(bitshift(x,-4),3)+1);
q1=bit2val(bitand(bitshift(x,-6),3)+1);
%ref=i0-j*q0;
ref=i1-j*q1;

%for m=210:280
%  t=[-m:m]/fs;
%  c=chirp(t,0,t(end),10e6);
%  c=c-j*c;
%  maxi(m)=max(abs(xcorr(c,ref)))
%end
%plot(maxi)
%return

t=[-247:247]/fs;  % 20 us pulsewidth according https://www.eoportal.org/satellite-missions/nisar#sweepsar-discussion "the 20 MHz pulse extent is 20 ms, while the 5 MHz pulse extent is 5 µs, giving a total pulse extent of 25 µs"
c=chirp(t,0,t(end),10e6);

clear d
max_PRI=600e-6;  % PRI < 600 us
min_PRI=400e-6;  % PRI > 400 us

Nmax=round(max_PRI*fs)  % distance between two PRI sweeps
Nmin=round(min_PRI*fs)  % distance between two PRI sweeps
m=1;
q=0;
refx=[];
p=1;r=1;
ng=1;
do
  refx=[refx(p:end) abs(xcorr(ref,c)(length(ref):end))]; % matches plot(abs(ref)*10)
  p=1;
  do
    [a(r),b]=max(abs(refx(p:p+Nmin)));
%    printf("%f %f\n",a(r),median(abs(refx(p:p+Nmax))))
    if (a(r)>threshold*median(abs(refx(p:p+Nmax))))
       b=b+p-1;
%      printf("pulse found: %d\n",p)
       kpos(m)=b+q;
       kval(m)=a(r);
       kmed(m)=median(abs(refx(p:p+Nmax)));
       p=b+Nmin;
       m=m+1;
    else
       p=p+Nmin;
%      printf("NG\n")
    end
    r=r+1;
  until (p>length(refx)-Nmax)
  x=fread(f,N,'uint8'); 
  i0=bit2val(bitand(x,3)+1);
  q0=bit2val(bitand(bitshift(x,-2),3)+1);
  i1=bit2val(bitand(bitshift(x,-4),3)+1);
  q1=bit2val(bitand(bitshift(x,-6),3)+1);
  %ref=i0-j*q0;
  ref=i1-j*q1;
  q=q+p-1;
until ((length(x)<N)|(m>4501));
save -mat kpos.mat kpos
