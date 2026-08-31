if (exist('filename')==0) filename='satpos_b210.txt';end
if (exist(filename)==2)
  satpos=load(filename);
  outname=strrep(filename,'.txt','-2.txt')
  t=-2.2
  M=[cosd(t) -sind(t) 0 ; sind(t) cosd(t) 0 ; 0 0 1] 
  s=satpos*M;
  eval(['save -ascii ',outname,' s']);

  outname=strrep(filename,'.txt','+2.txt')
  t=2.2
  M=[cosd(t) -sind(t) 0 ; sind(t) cosd(t) 0 ; 0 0 1] 
  s=satpos*M;
  eval(['save -ascii ',outname,' s']);
else
  printf("no input file\n");
end
