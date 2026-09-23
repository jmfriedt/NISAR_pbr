theta0 = 51*pi/180;
Nr = 2501;
P = 2501;
filename='max2771_12.bin';  % ref
addpath('../octave');
for kposstart=4000:500:5000
  nisarmax2771_process6
  title(num2str(kposstart))
end
