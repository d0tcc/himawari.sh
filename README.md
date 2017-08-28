# himawari.sh

I wanted something to give me a life wallpaper of earth, but most scripts clashed with the cronjob I wanted to set to update it.
It uses the publicly available images of the wonderful [Himawari-8](https://himawari8.nict.go.jp/) satellite.
This script uses standard bash tools like 'wget' and 'convert' to get the newest images and put them together to an all-earth image.
If you set the '-w' flag, it sets it as desktop background in gnome-based GUIs, otherwise you have to point your GUI to the generated image.

You also can make it a sort of sun-dial (earth-dial actually) by giving it an off-set to your local time. 
Me currently being based in central Europe, my crontab for an earth-clock background which updates every 10 minutes looks like this:
>*/10 * * * * bash /home/david/Programs/himawari/himawari.sh -o "7 hour ago" -b 5 -w /home/david/Pictures/Backgrounds/earth.png

You add it to your cronjobs with:
> crontab -e
