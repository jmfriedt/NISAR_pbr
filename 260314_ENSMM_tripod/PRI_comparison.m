cd ../260223_ENSMM_tripod_290deg_2emebalustrade/
load kpos
kpos2=kpos;
cd ../260314_ENSMM_tripod/
load kpos
subplot(211)
plot(kpos2(1:end-1)/22e6,diff(kpos2(1:end))/22e6)
hold on
plot(kpos(1:end-1)/22e6+0.1741,diff(kpos(1:end))/22e6)
axis([1.5 3.4 400e-6 1200e-6])
xlabel('time (s)')
ylabel('PRI (s)')
legend('Feb 23, 2026','Mar 14, 2026','location','northwest')

