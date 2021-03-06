# EverydayWallpaper
Everyday Wallpaper is a tool that automatically change your wallpaper every day, the wallpapers come from a Bing service.
The actual version is for OSX only.

## Microsoft Bing
Bing search engine is famous for using high-resolution images that feet perfectly to use for wallpapers, Images change everyday and they are relative to your geographic zone.

## Goal of EverydayWallpaper
Automatically change the wallpaper every day with the minimum impact possible on the CPU and the memory.

## The query

### Url
The Json url is:
```
http://www.bing.com/HPImageArchive.aspx?format=js&idx=IDX&n=1&mkt=zh-CN
```
### Parameter idx
The idx parameter is the start day index. 0 for current day, 1 for yesterday, etc..

NOTE; Limit for 'Idx' may vary, my last test product the limit to 25. For 'n' number of images the max value i 8.

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

## App launched at login
The app can be launched at login, we should know about a specific rule surrounding ‘launch at login’ in the Mac App Store developer requirements list.
This rule is outlined in the Mac App Store Review Guidelines document:

```
2.26 Apps that are set to auto-launch or to have other code automatically run at startup or login without user consent will be rejected
```

To meet this requirement I have included a check box that can be toggled by the user (label: Launch Everyday Wallpaper at login).
The setting is stored on the **LaunchedAtLogin** in application settings.

## Debugging
EverydayWallpaper use the [XCGLogger][4] library.
Application debug erros on */Users/hugo/Library/Logs/EverydayWallpaper* folder, by default errors are not logged (LogLevel = **None**).
You can optionally set a different log level for the file output using the LogLevel on the Info.plist application file.
Values for LogLevel are:
  1. Debug (show debug and sever logging)
  2. Severe (show only sever logging)
  3. None (no logs)
This value are not case sensitive, but it's better to format like defined.
In reality [XCGLogger][4] library use more log level, but EverydayWallaper only use a subset of lib log level.

## Create distribution DMG
Added submodule to create DMG from a shell script to build fancy DMGs.  

### Installation
  
By being a shell script, yoursway-create-dmg installation is very simple. Simply download and run.  
  
> git clone https://github.com/andreyvit/yoursway-create-dmg.git  
> cd yoursway-create-dmg  
> ./create-dmg [options]  
  
### Usage

> create-dmg [options...] [output\_name.dmg] [source\_folder]  

All contents of source\_folder will be copied into the disk image.  
  
**Options:**  
  
*   **--volname [name]:** set volume name (displayed in the Finder sidebar and window title)  
*   **--volicon [icon.icns]:** set volume icon    
*   **--background [pic.png]:** set folder background image (provide png, gif, jpg)    
*   **--window-pos [x y]:** set position the folder window    
*   **--window-size [width height]:** set size of the folder window    
*   **--text-size [text size]:** set window text size (10-16)    
*   **--icon-size [icon size]:** set window icons size (up to 128)    
*   **--icon [file name] [x y]:** set position of the file's icon    
*   **--hide-extension [file name]:** hide the extension of file    
*   **--custom-icon [file name]/[custom icon]/[sample file] [x y]:** set position and custom icon    
*   **--app-drop-link [x y]:** make a drop link to Applications, at location x, y    
*   **--eula [eula file]:** attach a license file to the dmg    
*   **--no-internet-enable:** disable automatic mount&copy    
*   **--version:** show tool version number    
*   **-h, --help:** display the help  
  
  
### Example
  
> \#!/bin/sh  
> test -f Application-Installer.dmg && rm Application-Installer.dmg  
> create-dmg \  
> --volname "Application Installer" \  
> --volicon "application\_icon.icns" \  
> --background "installer\_background.png" \  
> --window-pos 200 120 \  
> --window-size 800 400 \  
> --icon-size 100 \  
> --icon Application.app 200 190 \  
> --hide-extension Application.app \  
> --app-drop-link 600 185 \  
> Application-Installer.dmg \  
> source\_folder/  


<!-- Links  -->
[1]: https://developer.apple.com/library/mac/documentation/Performance/Conceptual/power_efficiency_guidelines_osx/SchedulingBackgroundActivity.html
[2]: https://github.com/tonymillion/Reachability
[3]: https://github.com/tonymillion/Reachability/wiki/Projects-using-Reachability
[4]: https://github.com/DaveWoodCom/XCGLogger
