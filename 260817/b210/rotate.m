load satpos.txt

t=-2.2
M=[cosd(t) -sind(t) 0 ; sind(t) cosd(t) 0 ; 0 0 1] 
s=satpos*M;
save -text satpos-2.txt s

t=2.2
M=[cosd(t) -sind(t) 0 ; sind(t) cosd(t) 0 ; 0 0 1] 
s=satpos*M;
save -text satpos+2.txt s
