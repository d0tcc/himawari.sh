#!/usr/bin/bash

while getopts o:c:b:pw option
do
	case "${option}"
	in
	o) offset=${OPTARG};;
	c) crop=${OPTARG};;
	b) border=${OPTARG};;
	p) print=true;;
	w) wallpaper=true;;
	esac
done

shift $((OPTIND-1))
if [ $# -le 0 ]; then
	echo $0"[-o offset, -c crop, -b border] <savefile>"
	echo 'Generates latest images from the Himawari8 satellite. Offset like this: "9 hour ago 30 minute ago", crop and border in percent.'
	exit 1
fi
outFile=$1

level=4d # level of detail, can be 4d, 8d, 16d, 20d
l=4 # same as level
width=550
latest=$(curl -s 'http://himawari8-dl.nict.go.jp/himawari8/img/D531106/latest.json' | grep -oP 'date":"\K.*?(?=")')
latest=$latest" "$offset
year=$(date --date="$latest" "+%Y")
month=$(date --date="$latest" "+%m")
day=$(date --date="$latest" "+%d")
hour=$(date --date="$latest" "+%H")
minute=$(date --date="$latest" "+%M")
minute=$(($minute - $minute%10))
second=$(date --date="$latest" "+%S")
printDate=$(date --date="$latest")
tmpPrefix='/tmp/.world_tile'

for ((i=0; i<$l; i++)); do
	for ((j=0; j<$l; j++)); do
		url='http://himawari8-dl.nict.go.jp/himawari8/img/D531106/'$level'/'$width'/'$year'/'$month'/'$day'/'$hour$minute$second'_'$i'_'$j'.png'
		tmpName=$tmpPrefix'_'$j'_'$i'.png'
		wget -q $url -O $tmpName || exit 1
	done
done
montage $tmpPrefix* -geometry +0+0 $outFile || exit 1
rm $tmpPrefix*

if [[ $crop ]]; then
	convert  $outFile -gravity Center -crop "0x$crop%+0+0" $outFile || exit 1
fi
if [[ $print ]]; then
	convert $outFile -gravity north -fill white -pointsize 72 -annotate 0 "$printDate" $outFile || exit 1
fi
if [[ $border ]]; then
	convert $outFile -bordercolor black -border $border% $outFile || exit 1
fi
if [[ $wallpaper ]]; then
	gsettings set org.gnome.desktop.background picture-uri "\"file://$outFile\""
fi
