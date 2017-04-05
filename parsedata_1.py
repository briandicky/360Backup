import sys
import math
fv=open(sys.argv[1], "r")
video=sys.argv[2]
fs=open('sensor_data.csv', "r")
fc=open(sys.argv[3], "r")
w=float(sys.argv[4])
h=float(sys.argv[5])
ctime=float(sys.argv[6])
vtime=float(sys.argv[7])
#cframenum=float(sys.argv[6])
#vframenum=float(sys.argv[7])
scframenum=float(sys.argv[8])
#svframenum=float(sys.argv[9])
fr=float(sys.argv[9])
fr_interval=1/fr
outgt=open(sys.argv[12],"w")
outs=open(sys.argv[13],"w")
tilew=float(sys.argv[10])
tileh=float(sys.argv[11])
#tmpw=open("/home/yibin/360videos/tmp/tmp.csv", "a")
cgt_yaw=[]
cgt_pitch=[]
outgt.write("no. frames, tile numbers\n")
outs.write("no. frames, raw x, raw y, raw z, raw yaw, raw pitch, raw roll, cal. yaw, cal. pitch, cal. roll\n")
# get calibration ground truth
for line in fc:
	arr=line.strip().split()
	interval=float(arr[0])	
	yaw=(float(arr[1])-w/2)/(w/2)*180
	pitch=math.atan((0-(float(arr[2])-h/2)/w)*2*math.pi)/math.pi*180
	for i in range(0,int((interval-3)*fr)):
		cgt_yaw.append(yaw)
		cgt_pitch.append(pitch)
#print cgt_yaw
#print cgt_yaw
# get the time of the first frame of calibration
for line in fv:
	arr=line.strip().split()
	time=float(arr[0])
	num=float(arr[1])
	if num==scframenum:
		sctime=time
		break
#print sctime
# calculate the time of the end of calibration
endcbtime=sctime+35
svtime=endcbtime+2
evtime=svtime+60
lasttime=0
curtime=0
fitst=0
bias_yaw=[]
bias_pitch=[]
mbias_yaw=[]
mbias_pitch=[]
nextitv=[sctime, sctime+5, sctime+10, sctime+15, sctime+20, sctime+25, sctime+30]
#print nextitv
k=0
j=0
i=0
m=0
first=0
count=0
gt_yaw=[]
gt_pitch=[]
mgt_yaw=[]
mgt_pitch=[]
flag=0
ftag= [0]*1800
#print sctime
#print ftag
m=0
mapped=0
for line in fs:
	first=first+1
	if first==1:
		continue
	arr=line.strip().split(',')
	curtime=float(arr[0])
	x=float(arr[1])
	y=float(arr[2])
	z=float(arr[3])
	yaw=float(arr[4])
	pitch=float(arr[5])
	roll=float(arr[6])
	mx=float(arr[16])
	my=float(arr[17])
	mz=float(arr[18])
	myaw=float(arr[19])
	mpitch=float(arr[20])
	mroll=float(arr[21])
#	if pitch >90 or pitch<-90:
#		print pitch
	if curtime<sctime+ctime-5:
		if curtime>=nextitv[k]+1.5 and curtime<nextitv[k]+3.5:
		#	print yaw, pitch, cgt_yaw[i], cgt_pitch[i],
		#	print curtime
			nexttime=nextitv[k]+1.5+float(j)*fr_interval
			if curtime>=nexttime and lasttime<nexttime:
			#	print curtime
				count=count+1
				j=j+1
				tmp_bias_yaw=cgt_yaw[i]-yaw
				if tmp_bias_yaw>=180:
					tmp_bias_yaw=360-tmp_bias_yaw
				elif tmp_bias_yaw<=-180:
					tmp_bias_yaw=tmp_bias_yaw+360
				bias_yaw.append(tmp_bias_yaw)
				tmp_bias_pitch=cgt_pitch[i]-pitch
				bias_pitch.append(tmp_bias_pitch)
				mtmp_bias_yaw=cgt_yaw[i]-myaw
                                if mtmp_bias_yaw>=180:
                                        mtmp_bias_yaw=360-mtmp_bias_yaw
                                elif mtmp_bias_yaw<=-180:
                                        mtmp_bias_yaw=mtmp_bias_yaw+360
                                mbias_yaw.append(mtmp_bias_yaw)
                                mtmp_bias_pitch=cgt_pitch[i]-mpitch
                                mbias_pitch.append(mtmp_bias_pitch)

		#		print yaw, pitch, cgt_yaw[i], cgt_pitch[i], tmp_bias_yaw, tmp_bias_pitch
				i=i+1
				#print j
		elif curtime>nextitv[k]+3.5:
			k=k+1
			j=0
	elif curtime>=sctime+ctime+2 and curtime < sctime+ctime+2+vtime:
		#print sctime+ctime+2, sctime+ctime+2+vtime
		bias_y=sum(bias_yaw)/float(len(bias_yaw))
		bias_x=sum(bias_pitch)/float(len(bias_pitch))
		mbias_y=sum(mbias_yaw)/float(len(mbias_yaw))
                mbias_x=sum(mbias_pitch)/float(len(mbias_pitch))
		nexttime=sctime+ctime+2+float(j)*fr_interval
		while curtime>=nexttime:
			nexttime=sctime+ctime+2+float(j)*fr_interval	
			#print j, curtime, nexttime
		#if curtime>=nexttime:
			m=m+1
			if m>1800:
				break
			tmpgty=yaw+bias_y
			if tmpgty>180:
				tmpgty=tmpgty%(-180)
			elif tmpgty<-180:
				tmpgty=tmpgty%(180)
			gt_yaw.append(tmpgty)
			tmpgtx=pitch+bias_x
			#if tmpgtx>90:
                        #        tmpgty=90
                        #elif tmpgtx<-90:
                        #        tmpgtx=-90
			gt_pitch.append(tmpgtx)
                        mtmpgty=myaw+mbias_y
                        if mtmpgty>180:
                                mtmpgty=mtmpgty%(-180)
                        elif mtmpgty<-180:
                                mtmpgty=mtmpgty%(180)
                        mgt_yaw.append(mtmpgty)
                        mtmpgtx=mpitch+mbias_x
                        #if mtmpgtx>90:
                        #        mtmpgty=90
                        #elif mtmpgtx<-90:
                        #        mtmpgtx=-90
                        mgt_pitch.append(mtmpgtx)
			#print m, curtime
			outs.write("%05d"%(m)+", "+str(x)+" ,"+str(y)+", "+str(z)+", "+str(yaw)+", "+str(pitch)+", "+str(roll)+", "+str(tmpgty)+", "+str(tmpgtx)+", "+str(roll)+"\n")
#			outs.write(video+"_%05d.png"%(m)+", "+str(yaw+bias_y)+", "+str(pitch+bias_x)+", "+str(roll)+", "+str(yaw)+", "+str(pitch)+", "+str(roll)+"\n")
		#	ftag[j]=1
			j=j+1
#			print j
	lasttime=curtime
#tmpw.write(str(bias_y)+", "+str(bias_x)+", "+str(mbias_y)+", "+str(mbias_x)+"\n")
#print bias_yaw
#print bias_pitch
#print bias_y, bias_x
#print sctime
#print sctime+ctime+2, sctime+ctime+2+vtime
#^^^^^^^^^ check ^^^^^^^^^^^^^^^^
R=w/(2*math.pi)
#x=R*30*math.pi/180
#y=R*math.tan(math.radians(-45))
#x_ori=x+1920
#y_ori=(0-y)+960
#print x_ori, y_ori
#tiles=[]
# get tile numbers
#print len(gt_yaw)
for i in range(0, len(gt_yaw)):
	tiles=[]
	# for all points in sphere FoV find the corresponding pixels and tiles
	# 1. circle center
	yaw=gt_yaw[i]
	pitch=gt_pitch[i]
	#if pitch>90:
	#	print pitch, yaw
	#elif pitch<-90:
#		print pitch, yaw
	# over top or bottom
	if pitch>90:
		pitch=pitch-90
		if yaw>0:
			yaw=yaw-180
		else:
			yaw=180+yaw
	elif pitch<-90:
		pitch=0-180-pitch
		if yaw>0:
			yaw=yaw-180
		else:
			yaw=180+yaw
	x=R*yaw*math.pi/180
	y=R*math.tan(math.radians(pitch))
	if y>959:
		y=959
	if y<-959:
		y=-959
	x_ori=x+1920
	y_ori=(0-y)+960
#	print x_ori, y_ori
	tile=math.floor(y_ori/(h/tileh))*tilew+math.floor(x_ori/(w/tilew))
	if tile not in tiles:
		tiles.append(tile)
	# 2. concentric circles
	for r in range(1, 50):
		#print r
		#yaw=gt_yaw[i]
		#rad=w/2*r/180
		unit=math.pi/180
		for p in range(0, 360):
			yaw=gt_yaw[i]+r*math.cos(unit*p)
			if yaw > 180:
				yaw=-360+yaw
			elif yaw < -180:
				yaw=yaw+360
	#		print yaw
			pitch=gt_pitch[i]+r*math.sin(unit*p)
			if pitch>90:
				pitch=pitch-90
				if yaw>0:
					yaw=yaw-180
				else:
					yaw=180+yaw
			elif pitch<-90:
				pitch=0-180-pitch
				if yaw>0:
					yaw=yaw-180
				else:
					yaw=180+yaw
	#		print yaw, pitch 
			x=R*yaw*math.pi/180
        		y=R*math.tan(math.radians(pitch))
			if y>959:
				y=959
			if y<-959:
				y=-959
		        x_ori=x+1920
		        y_ori=(0-y)+960
			#if x_ori>=3840:
		#		print x_ori
	#		if y_ori>=1920:
	#			print y_ori
		        tile=math.floor(y_ori/(h/tileh))*tilew+math.floor(x_ori/(w/tilew))
			if tile>200:
				print yaw, x, x_ori, tile	
			#if tile>=200:
#			print tile
#			print yaw, pitch, x, y
			#print tile
		        if tile not in tiles:
                		tiles.append(tile)
	tiles.sort()
	if i+1>1800:
		print "nononononononononononononononononononononono"
	outgt.write('%05d, '%(i+1))
	for j in range(0, len(tiles)):
		if j!=0:
			outgt.write(", ")
		outgt.write(str(int(tiles[j])))
	outgt.write("\n")
outgt.close()
outs.close()
#tmpw.close()
