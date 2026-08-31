filename1='2ref.bin';filename2='1sur.bin';
filename='2ref.bin';
theta0=44*pi/180;
kposstart=7005;

addpath('../../octave');

if ((exist(filename1)==2) && (exist(filename)!=2)) b210process;end    % not yet done
if ((exist(filename)==2) && (exist('b210_kpos.mat')==0)) go_b210;end  % produces b210_kpos

% frequency domain azimuth compression
if (exist('S_2501_2301_b210.mat')!=2) nisarb210_process5;end

% time domain azimuth compression
if (exist('tpos_b210.txt')!=2)
  load b210_kpos.mat
  t=kpos'/22e6;
  save -ascii tpos_b210.txt t
  printf("execute satpos.py > satpos_b210.txt to compute satellite position\n")
  printf("clean satpos.txt (remove [ and ]) to make the file Octave compatible\n")
end

if (exist('satpos_b210-2.txt')!=2)
  filename='satpos_b210.txt';
  satpos_rotate
end

b210tdbp=1
tdbp
% b210_ifft.mat b210_tdbp.mat S_2501_2301_b210.mat
