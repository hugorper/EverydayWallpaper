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
    // uncomment to use log
    //let log = XCGLogger.defaultInstance()

    enum SchedulUpdate
    {
        case OnFirstDayUpdate
        case LaterToday
        case Tomorrow
        case WhenNetworkAvailable
    }

    // activate desactive if uodateing
    //(popover.contentViewController as! EverydayWallpaperViewController).shouldShowSpinner()
    //(popover.contentViewController as! EverydayWallpaperViewController).shouldHideSpinner()

    func applicationDidFinishLaunching(notification: NSNotification)
    {

        // uncomment to use log
        //let logPath = NSBundle.mainBundle().bundlePath.stringByAppendingString("/log.log")
        //log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath, fileLogLevel: .Debug)

        
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
                        self.scheduleNextUpdate(SchedulUpdate.WhenNetworkAvailable)
                    }
                    catch DownloadStatus.UndefinedError
                    {
                        self.scheduleNextUpdate(SchedulUpdate.LaterToday)
                    }
                    catch
                    {
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
        if nextUpdate == SchedulUpdate.WhenNetworkAvailable
        {
            self.updateWallpaperOnNextNetworkConnect()

        }
        else
        {
            var timeToNextUpdate: NSTimeInterval = 0;

            if nextUpdate == SchedulUpdate.Tomorrow
            {
                let tomorrow = NSDate().tomorrowWithHour(7, minute: 10, second: 0)
                timeToNextUpdate = NSDate().timeIntervalSinceDate(tomorrow)
            }
            else if nextUpdate == SchedulUpdate.LaterToday
            {
                timeToNextUpdate = NSTimeInterval(60*10); // 10 minutes
            }
            else if nextUpdate == SchedulUpdate.OnFirstDayUpdate
            {
                let laterToday = NSDate().todayWithHour(7, minute: 10, second: 0)
                timeToNextUpdate = NSDate().timeIntervalSinceDate(laterToday)
            }

            BackgroundTaskScheduler.delay(timeToNextUpdate)
            {
                self.initWallpaperUpdate()

            }

        }
    }

    func updateWallpaperOnNextNetworkConnect()
    {
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
        var alternateWallpaper = todayWallpaper
        
        var naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: ScreenInfo.screensSizeFromIndex(0), withDate: NSDate(), withMarket: AppSettings.sharedInstance.MainCodePage)

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
                    AppSettings.sharedInstance.setBingUpdateHoursWithMarket(AppSettings.sharedInstance.MainCodePage, withTimeString: todayWallpaper!.FullStartTime)
                }

            }
            catch
            {
                print(error)
            }
        }

        if (true == true)
        {
            alternateWallpaper = try BingWallpaperService.GetTodayBingWallpaperReference(AppSettings.sharedInstance.AlternateCodePage)


            naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: ScreenInfo.screensSizeFromIndex(0), withDate: NSDate(), withMarket: AppSettings.sharedInstance.AlternateCodePage)

            ImageDownloader.sharedLoader.downloadImageFromUrl(alternateWallpaper!.Url, fileName: naming.fileName())
        }

        do
        {
            let imgurl = NSURL.fileURLWithPath(naming.fullName())
            let workspace = NSWorkspace.sharedWorkspace()
            if let screen = NSScreen.screens()?.last
            {

                try workspace.setDesktopImageURL(imgurl, forScreen: screen, options: [:])
            }

        }
        catch
        {
            print(error)
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

    // check if nework unavailable and call reachabilityChanged when network become available
//    func isWaitingForNextReachNeeded() -> Bool
//    {
//        if !self.reach!.isReachableViaWiFi() && !self.reach!.isReachableViaWWAN()
//        {
//            self.updateWallpaperOnNextNetworkConnect()
//
//            return true; }
//        else
//        {
//            return false; }
//    }

}
