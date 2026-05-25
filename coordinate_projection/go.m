in=[0 100;
    100 0;
    100 100 ];
out=[-3.83739442e+00  9.99032182e+01;
     9.99032450e+01  3.83742330e+00 ;
     9.60657949e+01  1.03740639e+02 ];
plot(in(:,1),in(:,2),'bo');hold on
plot(out(:,1),out(:,2),'ro');
latitude=47;
longitude=6;
zone_number=31; % UTM31N
longdiff=longitude-((zone_number-1.0)*6.0-180.0+3.0);
correction=atand(tand(longdiff)*sind(latitude))
R=[cosd(correction) -sind(correction) ; sind(correction) cosd(correction)];
out=out*R;
plot(out(:,1),out(:,2),'gx')
legend('input (UTM31N)','Skfield output (position wrt LocationC)','after rotation','location','west')
xlabel('X (m)')
ylabel('Y (m)')
axis([-10 105 -10 110])
