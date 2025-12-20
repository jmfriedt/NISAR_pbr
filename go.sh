# position in WGS84 coordinates
#lat=47.2469  # ground station latitude
#lon=5.9897   # ground station longitude
lon=2.24588
lat=48.87337

# convert WGS84 spherical to projected UTM32N
res=`echo $lon $lat | gdaltransform -s_srs EPSG:4326 -t_srs EPSG:32632 | tail -1`
lon=`echo $res | cut -d\  -f1`
lat=`echo $res | cut -d\  -f2`
# echo $lon $lat
# compute beam projection from radar angle and satellite altitude
res=`octave go.m $lon $lat`
hei=`echo $res | cut -d\  -f1`
lef=`echo $res | cut -d\  -f2`
rig=`echo $res | cut -d\  -f3`
# echo $hei $lef $rig
# convert projected UTM32N to spherical WGS84
res=`echo $lef $hei | gdaltransform -t_srs EPSG:4326 -s_srs EPSG:32632 | tail -1`
heil=`echo $res | cut -d\  -f2`
left=`echo $res | cut -d\  -f1`
res=`echo $rig $hei | gdaltransform -t_srs EPSG:4326 -s_srs EPSG:32632 | tail -1`
heir=`echo $res | cut -d\  -f2`
righ=`echo $res | cut -d\  -f1`

# predict next passes
echo ""
echo "LEFT: " $left $heil "(keep ascending = morning)"
cat predict_template.py | sed "s/LAT/$heil/g" | sed "s/LON/$left/g" > predict.py
python3 predict.py
echo ""
echo "RIGHT: " $righ $heir "(keep descending = evening)"
cat predict_template.py | sed "s/LAT/$heir/g" | sed "s/LON/$righ/g" > predict.py
python3 predict.py

