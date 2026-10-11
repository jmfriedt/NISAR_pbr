load max2771_kpos.mat 
kposmax=diff(kpos);
load b210_kpos.mat 
kposb210=diff(kpos);
pkg load signal
kposb210=kposb210/22e6;
kposmax=kposmax/24e6;
kposb210=kposb210(100:end-100);
kposmax=kposmax(2000:end-3100);
subplot(211);plot(kposb210);
subplot(212);plot(kposmax);
x=(abs(xcorr(kposb210-mean(kposb210),kposmax-mean(kposmax),3000)));
figure
subplot(311)
plot(x)
[a,b]=max(x);b=b-3000
subplot(312)
plot(kposb210)
hold on
kposmax=kposmax(-b+2:end);
plot(kposmax+1e-4)
subplot(313)
plot(kposb210(5000:7000)-kposmax(5000:7000));

load max2771_kpos.mat
kposmax=kpos/24e6;
kposmax=kposmax(2000:end);
kposmax=kposmax(-b+2:end);
load b210_kpos.mat 
kposb210=kpos/22e6;
kposb210=kposb210(100:end);

figure
subplot(211)
plot(kposb210-kposb210(5000))
hold on
plot(kposmax-kposmax(5000))
subplot(212)
dkpos=kposb210(5000:7000)-kposmax(5000:7000);
plot(dkpos-dkpos(1));
