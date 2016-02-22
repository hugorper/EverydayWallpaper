/*
* Created by Hugo PEREIRA
* Copyright © 2015 Hugo PEREIRA. All rights reserved.
*/

import Cocoa
import EverydayWallpaperUtils
import XCGLogger

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var defaultToolTipDelay: Int = 0
    var reach: Reachability?
    let enabledImageName: String = "StatusBarButtonImage"
    let disabledImageName: String = "StatusBarButtonImageDisabled"
    var statusBarImageName: String = "StatusBarButtonImage"
    var isUpdateProcessing: Bool = false
    var log: XCGLogger? = XCGLogger.defaultInstance()
    
    

    enum SchedulUpdate
    {
        case OnFirstDayUpdate
        case LaterToday
        case Tomorrow
        case WhenNetworkAvailable
    }

    func applicationDidFinishLaunching(notification: NSNotification)
    {
        let logPath = LogFilePathUtilHelper.UserLibraryLogFilePathForApp("EverydayWallpaper")
        
        if AppSettings.sharedInstance.LogLevel != XCGLogger.LogLevel.None
        {
            log!.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath, fileLogLevel: AppSettings.sharedInstance.LogLevel)
        }
        else
        {
            log = nil
        }

        log?.debug("Application start")
        
        self.reach = Reachability.reachabilityForInternetConnection()

        if let button = statusItem.button
        {
            self.updateImageNameFromState(false)

            button.image = NSImage(named: statusBarImageName)
            button.action = Selector("togglePopover:")
        }

        popover.contentViewController = EverydayWallpaperViewController(nibName: "EverydayWallpaperViewController", bundle: nil)

        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask])
        {
            [unowned self] event in if self.popover.shown
        {
            self.closePopover(event)
        }
        }
        eventMonitor?.start()

        self.initWallpaperUpdate()
    }


    func applicationWillTerminate(aNotification: NSNotification)
    {
        log?.debug("Application terminate")
        self.reach?.stopNotifier()
    }

    func updateImageNameFromState(isImageUpdated: Bool)
    {
        if AppSettings.sharedInstance.IsActivate
        {
            statusBarImageName = enabledImageName
        }
        else
        {
            statusBarImageName = disabledImageName
        }

        if isImageUpdated
        {
            if let button = statusItem.button
            {
                button.image = NSImage(named: statusBarImageName)
            }
        }

        self.initWallpaperUpdate()
    }

    func initWallpaperUpdate()
    {
        log?.debug("Init wallpaper update")
        
        let isProcessing = isUpdateProcessing

        if AppSettings.sharedInstance.IsActivate
        {
            if !isProcessing
            {
                isUpdateProcessing = true

                if self.isWallpaperUpdatedToday() == false
                {
                    do
                    {
                        try self.wallpaperUpdate()

                        self.scheduleNextUpdate(SchedulUpdate.Tomorrow)
                    }
                    catch DownloadStatus.NetworkNotReachable
                    {
                        log?.debug("Schedule next update -> WhenNetworkAvailable")
                        self.scheduleNextUpdate(SchedulUpdate.WhenNetworkAvailable)
                    }
                    catch DownloadStatus.UndefinedError
                    {
                        log?.debug("Schedule next update -> UndefinedError")
                        self.scheduleNextUpdate(SchedulUpdate.LaterToday)
                    }
                    catch
                    {
                        log?.debug("Schedule next update -> LaterToday")
                        self.scheduleNextUpdate(SchedulUpdate.LaterToday)
                    }
                }
                else
                {
                    self.scheduleNextUpdate(SchedulUpdate.Tomorrow)
                }

                isUpdateProcessing = false
            }
        }
    }

    func scheduleNextUpdate(nextUpdate: SchedulUpdate)
    {
        log?.debug("Schedule next update")
        
        if nextUpdate == SchedulUpdate.WhenNetworkAvailable
        {
            self.updateWallpaperOnNextNetworkConnect()

        }
        else
        {
            var timeToNextUpdate: NSTimeInterval = 0; let timeString: String = AppSettings.sharedInstance.getBingUpdateHoursWithMarket(AppSettings.sharedInstance.MainCodePage)
            let timeArray = timeString.componentsSeparatedByString(":")
            let hour = (timeArray[0] as NSString).integerValue
            let minute = (timeArray[1] as NSString).integerValue
            
            log?.debug("Next upodate time hour \(hour), minute \(minute) for market \(AppSettings.sharedInstance.MainCodePage) ")
            
            if nextUpdate == SchedulUpdate.Tomorrow
            {
                log?.debug("Next update Tomorrow")
                
                let tomorrow = NSDate().tomorrowWithHour(hour, minute: minute, second: 0)
                timeToNextUpdate = NSDate().timeIntervalSinceDate(tomorrow)
            }
            else if nextUpdate == SchedulUpdate.LaterToday
            {
                log?.debug("Next update LaterToday")
                
                timeToNextUpdate = NSTimeInterval(60 * 10); // 10 minutes
            }
            else if nextUpdate == SchedulUpdate.OnFirstDayUpdate
            {
                log?.debug("Next update OnFirstDayUpdate")
                
                let laterToday = NSDate().todayWithHour(hour, minute: minute, second: 0)
                timeToNextUpdate = NSDate().timeIntervalSinceDate(laterToday)
            }
            
            log?.debug("Time to next update \(timeToNextUpdate.absoluteValue())")
            
            BackgroundTaskScheduler.delay(timeToNextUpdate.absoluteValue())
            {
                self.initWallpaperUpdate()

            }
        }
    }

    func updateWallpaperOnNextNetworkConnect()
    {
        log?.debug("Update on next network connect")
        
        // Allocate a reachability object
        self.reach = Reachability.reachabilityForInternetConnection()

        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        self.reach!.reachableOnWWAN = false

        // Here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)

        self.reach!.startNotifier()
    }

    func reachabilityChanged(notification: NSNotification)
    {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN()
        {
            log?.debug("Network is now Reachble")
            self.reach!.stopNotifier()
            self.initWallpaperUpdate()
        }
    }

    func isWallpaperUpdatedToday() -> Bool
    {
        var isUpdatedToday = false
        var shortDateString = NSDate().toShortString()
        shortDateString.appendContentsOf(Constants.Naming.FileNameSeparator)

        if SearchFile.existFromDirectory(ImageDownloader.sharedLoader.WallpaperSavePath, withPrefix: shortDateString)
        {
            isUpdatedToday = true
        }

        return isUpdatedToday;
    }

    func wallpaperUpdate() throws
    {
        let todayWallpaper = try BingWallpaperService.GetTodayBingWallpaperReference(AppSettings.sharedInstance.MainCodePage)

        let naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: ScreenInfo.screensSizeFromIndex(0), withDate: NSDate(), withMarket: AppSettings.sharedInstance.MainCodePage)

        ImageDownloader.sharedLoader.downloadImageFromUrl(todayWallpaper!.Url, fileName: naming.fileName())

        let success: Bool = NSFileManager.defaultManager().fileExistsAtPath(naming.fullName())

        if (success)
        {
            do
            {
                let imgurl = NSURL.fileURLWithPath(naming.fullName())
                let workspace = NSWorkspace.sharedWorkspace()
                if let screen = NSScreen.mainScreen()
                {
                    try workspace.setDesktopImageURL(imgurl, forScreen: screen, options: [:])

                    // save the hour of wallpaper availybility for a specific market.
                    AppSettings.sharedInstance.setBingUpdateHoursWithMarket(AppSettings.sharedInstance.MainCodePage, withTimeString: todayWallpaper!.FullStartTime)
                }

            }
            catch
            {
                log?.severe("\(error)")
            }
        }

        do
        {
            let imgurl = NSURL.fileURLWithPath(naming.fullName())
            let workspace = NSWorkspace.sharedWorkspace()

            for screen in NSScreen.screens()!
            {
                try workspace.setDesktopImageURL(imgurl, forScreen: screen, options: [:])
            }
        }
        catch
        {
            log?.severe("\(error)")
        }
    }

    func togglePopover(sender: AnyObject?)
    {
        if popover.shown
        {
            closePopover(sender)
        }
        else
        {
            showPopover(sender)
        }
    }

    func showPopover(sender: AnyObject?)
    {
        if let button = statusItem.button
        {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        eventMonitor?.start()
    }

    func closePopover(sender: AnyObject?)
    {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}
