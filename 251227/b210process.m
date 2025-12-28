pkg load signal
dirlist=dir('/t/films/b210_L1_6MSps.bin');
fs=6e6;
f=fopen(['/t/films/',dirlist.name]);
%fseek(f,295*fs*2)
%N=fs*10;
%d=fread(f,2*N,'int8');d=d(1:2:end)+j*d(2:2:end);
%return

%fseek(f,5*fs*2,SEEK_CUR)
N=fs/100;
d=fread(f,2*N,'int8');d=d(1:2:end)+j*d(2:2:end);
%return
m=1;

while ((length(d)==N))
   a(m)=std(abs(d));
   x(m)=max(abs(xcorr(d))(N+1000:N+5000));
   m=m+1;
   d=fread(f,2*N,'int8');d=d(1:2:end)+j*d(2:2:end);
   waitbar((m-1)*N*2/dirlist.bytes)
end
subplot(211)
plot([0:length(a)-1]/fs*N,a);
ylabel('power (a.u.)')
subplot(212)
plot([0:length(x)-1]/fs*N,x);
xlabel('time (s)')
ylabel('autocorrelation (a.u.)')
