HEAD=$PWD
echo -e "\nCurrent working directory is $HEAD"
echo "."
sleep 1
echo "."
sleep 1


mkdir tiled_images 2> /dev/null
cd tiled_images
mkdir raw_yuv 2> /dev/null
cd raw_yuv
rm *.yuv

allpng=($HEAD/equir/*.png)

echo -e "\nNow we have the images below, then convert them to yuv..."
echo "------------------------------------------------"
for png in ${allpng[@]}; do
    echo "$png"
    png_name=`basename "$png"`
    ffmpeg -i $png -pix_fmt yuv420p ${png_name%%.*}.yuv 2> /dev/null
    echo "Convert: $png done."
done
echo "------------------------------------------------"
echo "."
sleep 1
echo "."
sleep 1

echo "------------start to concate mutilple yuv to single yuv-------------"
allyuv=(*.yuv)
yuv_name=${allyuv[0]%%0*}

for yuv in ${allyuv[@]}; do
    cat $yuv >> ${yuv_name}1min.yuv
done

echo "Concate: ${yuv_name}1min.yuv done."
echo "------------end of concating-------------"
echo "."
sleep 1
echo "."
sleep 1
