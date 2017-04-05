import sys
import math

R=3840/(2*math.pi)
if cyaw>180:
        cyaw=cyaw%(-180)
elif cyaw<-180:
        cyaw=cyaw%(180)
if cpitch>90:
        cpitch=cpitch-90
        if cyaw>0:
                cyaw=cyaw-180
        else:
                cyaw=180+cyaw
elif cpitch<-90:
        cpitch=0-180-cpitch
        if cyaw>0:
                cyaw=cyaw-180
        else:
                cyaw=180+cyaw
x=R*cyaw*math.pi/180
y=R*math.tan(math.radians(cpitch))
if y>959:
        y=959
if y<-959:
        y=-959
x_ori=x+1920
y_ori=(0-y)+960
