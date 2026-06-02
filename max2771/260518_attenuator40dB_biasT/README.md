# MAX2771 recording at 24 MS/s on two separate channels

Configuration:
```
$ PocketSDR/app/pocket_conf/pocket_conf pocket_NISAR_24MHz.conf 
$ PocketSDR/app/pocket_conf/pocket_conf
#
#  Pocket SDR device settings (MAX2771)
#
#  [CH1] F_LO =  1229.025000 MHz, F_ADC = 24.000000 MHz (IQ), F_FILT =  0.0 MHz, BW_FILT = 23.4 MHz
#  [CH2] F_LO =  1229.025000 MHz, F_ADC =  0.000000 MHz (IQ), F_FILT =  0.0 MHz, BW_FILT = 23.4 MHz

[CH1]
LNAMODE         =       1  # LNA mode selection (0:high-band,1:low-band,2:disable)
MIXERMODE       =       1  # Mixer mode selection (0:high-band,1:low-band,2:disable)
FCEN            =       0  # IF filter center frequency: (128-FCEN)/2*{0.195|0.66|0.355} MHz
FBW             =       3  # IF filter BW (0:2.5MHz,1:8.7MHz,2:4.2MHz,3:23.4MHz,4:36MHz,7:16.4MHz)
F3OR5           =       1  # Filter order selection (0:5th,1:3rd)
FCENX           =       0  # Polyphase filter selection (0:lowpass,1:bandpass)
FGAIN           =       1  # IF filter gain setting (0:-6dB,1:normal)
IQEN            =       1  # I and Q channel enable (0:I-CH-only,1:I/Q-CH)
GAINREF         =     170  # AGC gain reference value (0-4095)
AGCMODE         =       0  # AGC mode control (0:independent-I/Q,2:gain-set-by-GAININ)
GAININ          =      58  # PGA gain value programming in steps of approx 1dB per LSB (0-63)
FHIPEN          =       0  # Enable highpass coupling between filter and PGA (0:disable,1:enable)
PGAIEN          =       1  # I-CH PGA enable (0:disable,1:enable)
PGAQEN          =       1  # Q-CH PGA enable (0:disable,1:enable)
LOBAND          =       1  # Local oscillator band selection (0:L1,1:L2/L5)
INT_PLL         =       1  # PLL mode control (0:fractional-N,1:integer-N)
NDIV            =   16387  # PLL integer division ratio (36-32767): F_LO=F_XTAL/RDIV*(NDIV+FDIV/2^20)
RDIV            =     320  # PLL reference division ratio (1-1023)
FDIV            =       0  # PLL fractional division ratio (0-1048575)
PREFRACDIV_SEL  =       0  # Clock pre-divider selection (0:bypass,1:enable)
REFCLK_L_CNT    =    2000  # Clock pre-divider L counter value (0-4095): L_CNT/(4096-M_CNT+L_CNT)
REFCLK_M_CNT    =    1296  # Clock pre-divider M counter value (0-4095)
ADCCLK          =       0  # Integer clock div/mul selection (0:enable,1:bypass)
REFDIV          =       3  # Integer clock div/mul ratio (0:x2,1:1/4,2:1/2,3:x1,4:x4)
FCLKIN          =       0  # ADC clock divider selection (0:bypass,1:enable)
ADCCLK_L_CNT    =       0  # ADC clock divider L counter value (0-4095): L_CNT/(4096-M_CNT+L_CNT)
ADCCLK_M_CNT    =       0  # ADC clock divider M counter value (0-4095)

[CH2]
LNAMODE         =       1  # LNA mode selection (0:high-band,1:low-band,2:disable)
MIXERMODE       =       1  # Mixer mode selection (0:high-band,1:low-band,2:disable)
FCEN            =       0  # IF filter center frequency: (128-FCEN)/2*{0.195|0.66|0.355} MHz
FBW             =       3  # IF filter BW (0:2.5MHz,1:8.7MHz,2:4.2MHz,3:23.4MHz,4:36MHz,7:16.4MHz)
F3OR5           =       1  # Filter order selection (0:5th,1:3rd)
FCENX           =       0  # Polyphase filter selection (0:lowpass,1:bandpass)
FGAIN           =       1  # IF filter gain setting (0:-6dB,1:normal)
IQEN            =       1  # I and Q channel enable (0:I-CH-only,1:I/Q-CH)
GAINREF         =     170  # AGC gain reference value (0-4095)
AGCMODE         =       0  # AGC mode control (0:independent-I/Q,2:gain-set-by-GAININ)
GAININ          =      58  # PGA gain value programming in steps of approx 1dB per LSB (0-63)
FHIPEN          =       0  # Enable highpass coupling between filter and PGA (0:disable,1:enable)
PGAIEN          =       1  # I-CH PGA enable (0:disable,1:enable)
PGAQEN          =       1  # Q-CH PGA enable (0:disable,1:enable)
LOBAND          =       1  # Local oscillator band selection (0:L1,1:L2/L5)
INT_PLL         =       1  # PLL mode control (0:fractional-N,1:integer-N)
NDIV            =   16387  # PLL integer division ratio (36-32767): F_LO=F_XTAL/RDIV*(NDIV+FDIV/2^20)
RDIV            =     320  # PLL reference division ratio (1-1023)
FDIV            =       0  # PLL fractional division ratio (0-1048575)
```

Data collection:
```
$ sudo nice -n -20 PocketSDR/app/pocket_dump/pocket_dump -t 120 /tmp/1.bin /tmp/2.bin
  TIME(s)    T   CH1(Bytes)   T   CH2(Bytes)   RATE(Ks/s)
^C     53.4   IQ   2678325248  IQ   2678325248      25056.8
```
failed after 53 seconds (shorter than the planned 120 s)

```
$ stat /tmp/1.bin
  File: /tmp/1.bin
  Size: 2678325248	Blocks: 5231104    IO Block: 4096   regular file
Device: 0,40	Inode: 108502      Links: 1
Access: (0664/-rw-rw-r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2026-05-18 20:42:34.236513576 +0200
Modify: 2026-05-18 20:43:30.198551193 +0200
Change: 2026-05-18 20:43:30.198551193 +0200
 Birth: 2026-05-18 20:42:34.236513576 +0200
```

Keep only the relevant data and rename according to channel function
```
$ cat 2.bin | head -c 1008000000 | tail -c 336000000 > ref.bin
$ cat 1.bin | head -c 1008000000 | tail -c 336000000 > sur.bin
```

<img src="Layout.png">
