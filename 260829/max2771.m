filename='12zoom.bin';
theta0=44*pi/180;
kposstart=7601;

addpath('../octave');

if (exist(filename)!=2) max2771process_packed;end                                  % not yet done
if ((exist(filename)==2) && (exist('max2771_kpos.mat')==0)) go_max2771_packed;end  % produces b210_kpos

% frequency domain azimuth compression
if (exist('S_2501_2301_max2771.mat')!=2) nisarmax2771_process6 ;end

% time domain azimuth compression
if (exist('tpos_max2771.txt')!=2)
  load max2771_kpos.mat
  t=kpos'/24e6;
  save -ascii tpos_max2771.txt t
  printf("execute satpos.py > satpos_max2771.txt to compute satellite position\n")
  printf("clean satpos.txt (remove [ and ]) to make the file Octave compatible\n")
  exit()
end

if (exist('satpos_max2771-2.txt')!=2)
  filename='satpos_max2771.txt';
  satpos_rotate
end

b210tdbp=0
tdbp
