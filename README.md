# EverydayWallpaper
OS X and Windows preference tool that changes your wallpaper every day, this version load only Bing wallpapers.

# Bing wallpaper
This apps download the Bing background image and set the desktop wallpaper.

Limit for 'Idx' may vary, my last test product the limit to 25. For 'n' number of images the max value i 8. 

## The query

### Url
The Json url is:
```html
http://www.bing.com/HPImageArchive.aspx?format=js&idx=IDX&n=1&mkt=zh-CN"
```
### Parameter idx
The idx parameter is the start day index. 0 for current day, 1 for yesterday, etc..

### Parameter mkt
List of 8 markets where Bing is available for wallpaper.
Valid values are: en-US, zh-CN, ja-JP, en-AU, en-UK, de-DE, 
    en-NZ, en-CA.

### Parameter n
Number of images 1 for one, 2 for two and so on.

## Result (sample output)
````json
{
  "images": [
    {
      "startdate": "20151130",
      "fullstartdate": "201511300800",
      "enddate": "20151201",
      "url": "/az/hprichbg/rb/Modica_EN-US11378362609_1920x1080.jpg",
      "urlbase": "/az/hprichbg/rb/Modica_EN-US11378362609",
      "copyright": "Modica, Sicily, Italy (© Robert Harding World Imagery/Offset)",
      "copyrightlink": "http://www.bing.com/search?q=Modica,+Sicily,+Italy&form=hpcapt&filters=HpDate:%2220151130_0800%22",
...
````

The values used by the apps are 'startdate', 'enddate' and 'urlbase'. Unlike 'url' the 'url base' contain a part of the full image path, to have to full one I must concat the resolution of the image.

### Resolution
List of supported resolutions:

````js
"176x220", "220x176", "240x240", "240x320", "240x400", "320x240", "320x320", "360x480", "400x240", "480x360", "480x640", "480x800", "640x480", "768x1024", "800x480", "800x600", "1024x768", "1280x720", "1280x768", "1366x768", "1920x1080", "1920x1200"
````


## Create OSX PreferencePane icon

Online icon creator
https://iconverticons.com/online/
