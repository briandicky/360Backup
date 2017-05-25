import sys
import subprocess

filename = sys.argv[1]

f = open(filename,'r')

http_prefix = 'http://download.tsi.telecom-paristech.fr/gpac/SRD/srd_hevc/multi_rate_p60/'

sub_folder = 'srd_hevc'
subprocess.call("mkdir %s" % sub_folder, shell=True)
subprocess.call("cd %s" % sub_folder, shell=True)

for line in f:
    
    if "VID" in line:

	subline = line[line.find('href='):]
	href = subline[subline.find('"')+1:]
	href = href[:href.find('"')]

	print "[Parser] Downloading %s ..." % href

	subprocess.call("wget %s%s" % (http_prefix,href), shell=True)

	#raw_input()
