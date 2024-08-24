#!/bin/bash

sed -i "s/Resolution 960 1009/Resolution 1920 2018/g" $1
sed -i "s/Antialiasing 12/Antialiasing 48/g" $1
sed -i "s/Samples 12/Samples 48/g" $1

name=`basename --suffix=.dat $1`

/usr/local/shared/vmd/1.9.3/64/lib/tachyon_LINUXAMD64 $1 -o $name.tga
convert $name.tga $name.jpg
rm $name.tga
