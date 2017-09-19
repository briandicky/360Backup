import sys
import math
import csv

reader = open(sys.argv[1], 'rb')
writer = open(sys.argv[2], 'wb')

total_bytes = 0
total_time = 0
index = 0

reader.next()

for line in reader:
    arr=line.strip().split(",")
    try:
        size = int(arr[1])
        time = float(arr[5])
        total_bytes += size
        total_time += time
        index += 1

        #if abs(total_time - 1.0) <= 0.0001:
        if total_time >= 1.0:
        #if 1:
            writer.write(str(index))
            writer.write(",")
            writer.write(str(total_bytes))
            #writer.write(",")
            #writer.write(str(total_time))
            writer.write("\n")
            total_time -= 1.0
            total_bytes = 0
    except IndexError:
        pass

if total_bytes != 0:
    writer.write(str(index))
    #writer.write(",")
    #writer.write(str(total_time))
    writer.write(",")
    writer.write(str(total_bytes))

reader.close()
writer.close()
