load max2771_kpos.mat
t=kpos'/24e6;
save -ascii tpos_max2771.txt t

load b210_kpos.mat
t=kpos'/22e6;
save -ascii tpos_b210.txt t

