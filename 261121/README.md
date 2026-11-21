# MAX2771 acquistion (B210 failed)

<img src="2026-11-21-194649_1024x768_scrot.png">

```
raspberrypi:~ $ sudo ./PocketSDR/app/pocket_conf/pocket_conf pocket_NISAR_24MHz.conf
Pocket SDR device settings are changed.
raspberrypi:~ $ sudo rm /tmp/*bin* && sudo ./PocketSDR/app/pocket_dump/pocket_dump -t 60  -r /tmp/12.bin
 TIME(s)      RAW8(B) RATE(Ks/s)
    60.0   1439694848    23992.9
```

```
octave:> 34*24e6
ans = 816000000
octave:> 12*24e6
ans = 288000000
head -c 816000000 12.bin | tail -c 288000000 > 12cut.bin
```

go_max2771_packed.m
max2771_all.mat.gz
max2771_all.png
max2771_alpha_beta.png
max2771_ifft.mat
max2771_kpos.mat
max2771process_packed.m
max2771_XY.png
max2771_zoom.mat.gz
max2771_zoom.png
nisarmax2771_process6.m
README.md
S_2501_2301_max2771.mat
