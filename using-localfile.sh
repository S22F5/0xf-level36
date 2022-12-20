## create filestructure
mkdir 1
mkdir 2

## move initial image
mv index.png 1/or.png


## clean up image for better processing
convert 1/or.png -solarize 1 1/o.png


## split image into individual pixels
convert 1/o.png -crop 9999x1 1/%d.png




rollimage () {
  roll=$(convert $1 -fuzz 58% -trim - | identify - | grep -Po '\+\K[^+]*'  | head -1)
  y=${1%.bar}
  convert $1 -roll -$roll 2/rolled${y##*/}.jpg
}

## cleanup, remove if you want summary image
rm 1/or.png 1> /dev/null
rm 1/o.png 1> /dev/null

## rollimages
for f in 1/*.png; do
	rollimage $f
  done

## cleanup
rm -Rvf 1/ 1> /dev/null

## recreate image
convert $(ls -v 2/*.jpg) -append  full_img.png
convert -colorspace gray  -threshold 10% -resize 480% -sharpen 10 -negate full_img.png out.png

## cleanup
rm -Rvf 2/ 1> /dev/null

tesseract out.png o
cat o.txt
printf "done"

