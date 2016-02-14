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

```js
{
  "images": [
    {
      "startdate": "20151130",
      "fullstartdate": "201511300800",
      "enddate": "20151201",
      "url": "/az/hprichbg/rb/Modica_EN-US11378362609_1920x1080.jpg",
      "urlbase": "/az/hprichbg/rb/Modica_EN-US11378362609",
      "copyright": "Modica, Sicily, Italy (© Robert Harding World Imagery/Offset)",
      "copyrightlink": "http://www.bing.com/search?q=Modica,+Sicily,+Italy&form=hpcapt&filters=HpDate:%2220151130_0800%22"

```

The values used by the apps are 'startdate', 'enddate' and 'urlbase'. Unlike 'url' the 'url base' contain a part of the full image path, to have to full one I must concat the resolution of the image.

### Resolution
List of supported resolutions:

```js
"176x220", "220x176", "240x240", "240x320", "240x400", "320x240", "320x320", "360x480", "400x240", "480x360", "480x640", "480x800", "640x480", "768x1024", "800x480", "800x600", "1024x768", "1280x720", "1280x768", "1366x768", "1920x1080", "1920x1200"
```

## Schedule Background Wallpaper Update Task
One of the most important aspect of this application is how and when call the wallpaper update. In order to be efficient I will not use the NSTimer class, some appropriate APIs helps to perform background tasks by limiting impact on the system and increase energy efficiency.

For more information about the APIs go to [Schedule Background Activity][1]

### Task scheduling
To goal is to update the wallpaper each day, the task will be scheduled each day at 07:10 UTC0.

If task fail and the computer is not connected to internet, the task is delayed until it's connected.
This mechanisms will be managed using [Reachability library][2] and EverydayWallpaper is referenced on the [list of project using Reachability][3]. If you plan to use Reachability don't miss the list when you use it.

## Debugging
EverydayWallpaper use the [XCGLogger][4] library.
Application debug erros on */Users/hugo/Library/Logs/EverydayWallpaper* folder, by default **Severe** errors are logged.
You can optionally set a different log level for the file output using the LogLevel on the plist application file.
Values for LogLevel are:
  1. Debug
  2. Severe
  3. None
This value are not case sensitive, but it's better to format like defined.
In reality [XCGLogger][4] library use more log level, but EverydayWallaper only use a subset of lib log level.


<!-- Links  -->
[1]: https://developer.apple.com/library/mac/documentation/Performance/Conceptual/power_efficiency_guidelines_osx/SchedulingBackgroundActivity.html
[2]: https://github.com/tonymillion/Reachability
[3]: https://github.com/tonymillion/Reachability/wiki/Projects-using-Reachability
[4]: https://github.com/DaveWoodCom/XCGLogger
