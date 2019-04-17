for f in *.jpg
do 
  extension="${f##*.}"
  filename="${f%.*}"
  convert $f -resize 800 $filename"-p-800.jpg"
  convert $f -resize 500 $filename"-p-500.jpg"
done

