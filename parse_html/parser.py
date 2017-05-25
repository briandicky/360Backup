import sys
import subprocess

filename = sys.argv[1]


f = open(filename,'r')

http_prefix = 'http://download.tsi.telecom-paristech.fr/gpac/SRD/tears_of_steal/'

for line in f:
    
    if "VID" in line:

	subline = line[line.find('href='):]
	href = subline[subline.find('"')+1:]
	href = href[:href.find('"')]

	print "[Parser] Downloading %s ..." % href

	subprocess.call("wget %s%s" % (http_prefix,href), shell=True)

	raw_input()
