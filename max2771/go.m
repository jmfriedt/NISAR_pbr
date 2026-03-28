if exist ('OCTAVE_VERSION')
  pkg load signal
end

fs=24e6;
N=fs/100;
f=fopen('2.bin');

%fseek(f1,3*fs*2*2);  % for searching the chirp shape
%fseek(f2,3*fs*2*2);  % for searching the chirp shape

d=fread(f,N*2,'int8'); ref=d(1:2:end)+j*d(2:2:end);

t=[-240:240]/fs;  % 20 us pulsewidth according https://www.eoportal.org/satellite-missions/nisar#sweepsar-discussion "the 20 MHz pulse extent is 20 ms, while the 5 MHz pulse extent is 5 µs, giving a total pulse extent of 25 µs"
c=chirp(t,0,t(end),10e6);

clear d
max_PRI=600e-6;  % PRI < 600 us
min_PRI=400e-6;  % PRI > 400 us

Nmax=round(max_PRI*fs)  % distance between two PRI sweeps
Nmin=round(min_PRI*fs)  % distance between two PRI sweeps
threshold=8
m=1;
q=0;
refx=[];
p=1;r=1;
do
  refx=[refx(p:end) ; xcorr(ref,c)(length(ref):end)]; % matches plot(abs(ref)*10)
  p=1;
  do
    [a(r),b]=max(abs(refx(p:p+Nmin)));
%    printf("%f %f\n",a(r),median(abs(refx(p:p+Nmax))))
    if (a(r)>threshold*median(abs(refx(p:p+Nmax))))
       b=b+p-1;
%      printf("pulse found: %d\n",p)
       kpos(m)=b+q;
       kval(m)=a(r);
%      if (m>1) 
%          if ((kpos(m)-kpos(m-1))>Nmax) || ((kpos(m)-kpos(m-1))<Nmin)
%             plot([0:Nmin]/fs*1e6,abs(refx(p:p+Nmin)));title(['problem ',num2str(kpos(m)-kpos(m-1))]);pause
%          end
%      end
 %      if (mod(m,20)==0) 
 %        plot(abs(refx(p:p+Nmin)));title('OK');pause
 %      end
       p=b+Nmin;
       m=m+1;
    else
       p=p+Nmin;
 %      printf("NG\n")
    end
    r=r+1;
  until (p>length(refx)-Nmax)
  d=fread(f,N*2,'int8'); ref=d(1:2:end)+j*d(2:2:end);
  q=q+p-1;
until (length(d)<N*2);
