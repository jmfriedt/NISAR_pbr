Sample processing software for M2SDR records interleaving reference and surveillance channels
in a single file.

1. run ``b210process.m`` to assess whether a signal was recorded, plotting the maximum amplitude
, autocorrelation and cross-correlation with a synthetic chirp
2. having identified the first and last sample including a spaceborne radar signal, truncate
the recording to the useful size
```
cat /t/tmp.bin | head -c 3696000000 | tail -c 1232000000 > /tmp/m2sdr.bin
```
since (GNU/Octave)
```
format long
fs*2*2*21*2
ans = 3696000000
fs*2*2*7*2
ans = 1232000000
```
to keep a 7 s long record ending 21 s from the beginning of the recording.
3. identify the pulse position on the reference channel using ``go.m`` which
generates ``kpos.mat``. One might load this variable and plot (GNU/Octave) ``diff(kpos)``
to check the PRI
4. execute ``nisar_process5.m`` to generate the range-azimuth map of reflectors
