pkg load signal

load all.mat
xx1max=xx1;xx1max=abs(xx1max);xx1max=xx1max-min(xx1max);xx1max=xx1max/max(xx1max);
xx2max=xx2;xx2max=abs(xx2max);xx2max=xx2max-min(xx2max);xx2max=xx2max/max(xx2max);
load ../b210/all.mat
xx1=abs(xx1);xx1=xx1-min(xx1);xx1=xx1/max(xx1);
xx2=abs(xx2);xx2=xx2-min(xx2);xx2=xx2/max(xx2);
fsmax=24e6; Nmax=fsmax/100;
fs=22e6; N=fs/100;
plot(abs(xcorr(xx2-mean(xx2),xx1-mean(xx1))))
figure
plot([0:length(xx2max)-1]/fsmax*Nmax-17.3,xx2max)
hold on
plot([0:length(xx2)-1]/fs*N,xx1)
% 3934.8-3040=894.80
