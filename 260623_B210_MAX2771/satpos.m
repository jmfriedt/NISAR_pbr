load b210_kpos.mat
tpos=kpos'/24e6;
save -ascii tpos_b210.txt tpos
printf("ln -s tpos_b210.txt tpos.txt\n");
printf("python3 satpos.py  > satpos_b210.txt\n");
printf("octave ../octave/satpos_rotate.m\n");
