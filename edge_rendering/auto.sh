#!/bin/bash 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:/ssd/bin
export PATH

video=(coaster2)

mkdir auto
cd auto 
mkdir 3x3 
cd 3x3
mkdir backup
cd backup

kvazaar -i ../../../${video}_equir.yuv --input-res=3840x1920 --input-fps 30.0 --tiles 3x3 --slices tiles --mv-constraint frametilemargin --bitrate 100000000 -o video_tiled_high.hvc
kvazaar -i ../../../${video}_equir.yuv --input-res=3840x1920 --input-fps 30.0 --tiles 3x3 --slices tiles --mv-constraint frametilemargin --bitrate 10000000 -o video_tiled_medium.hvc
kvazaar -i ../../../${video}_equir.yuv --input-res=3840x1920 --input-fps 30.0 --tiles 3x3 --slices tiles --mv-constraint frametilemargin --bitrate 1000000 -o video_tiled_low.hvc

MP4Box -add video_tiled_high.hvc:split_tiles -new video_tiled_high.mp4
MP4Box -add video_tiled_medium.hvc:split_tiles -new video_tiled_medium.mp4
MP4Box -add video_tiled_low.hvc:split_tiles -new video_tiled_low.mp4

cd ..
MP4Box -dash 4000 -profile live -out dash.mpd ./backup/video_tiled_low.mp4 ./backup/video_tiled_medium.mp4 ./backup/video_tiled_high.mp4


cd ..
mkdir 5x5 
cd 5x5 
mkdir backup 
cd backup

kvazaar -i ../../../${video}_equir.yuv --input-res=3840x1920 --input-fps 30.0 --tiles 5x5 --slices tiles --mv-constraint frametilemargin --bitrate 100000000 -o video_tiled_high.hvc
kvazaar -i ../../../${video}_equir.yuv --input-res=3840x1920 --input-fps 30.0 --tiles 5x5 --slices tiles --mv-constraint frametilemargin --bitrate 10000000 -o video_tiled_medium.hvc
kvazaar -i ../../../${video}_equir.yuv --input-res=3840x1920 --input-fps 30.0 --tiles 5x5 --slices tiles --mv-constraint frametilemargin --bitrate 1000000 -o video_tiled_low.hvc

MP4Box -add video_tiled_high.hvc:split_tiles -new video_tiled_high.mp4
MP4Box -add video_tiled_medium.hvc:split_tiles -new video_tiled_medium.mp4
MP4Box -add video_tiled_low.hvc:split_tiles -new video_tiled_low.mp4

cd ..
MP4Box -dash 4000 -profile live -out dash.mpd ./backup/video_tiled_low.mp4 ./backup/video_tiled_medium.mp4 ./backup/video_tiled_high.mp4
