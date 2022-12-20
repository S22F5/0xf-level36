## create filestructure
mkdir 1
mkdir 2

## download initial image
curl  https://0xf.at/play/36 | grep "data:image" | grep -Po '\,\K[^"]*' | base64 -d > 1/or.png


## clean up image for better processing
convert 1/or.png -solarize 1 1/o.png


## split image into individual pixels
convert 1/o.png -crop 400x1 1/%d.png




rollimage () {
  roll=$(convert $1 -fuzz 58% -trim - | identify - | grep -Po '\+\K[^+]*'  | head -1)
  y=${1%.bar}
  convert $1 -roll -$roll 2/rolled${y##*/}
}


## rollimages
for f in 1/*.png; do
	rollimage $f
  done


## recreate image
convert 2/rolled*.png -append  full_img.png


##cleanup
rm -Rvf 1/
rm -Rvf 2/



feh full_img.png
printf "done"

