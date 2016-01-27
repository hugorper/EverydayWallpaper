/*
* Created by Hugo PEREIRA
* Copyright © 2015 Hugo PEREIRA. All rights reserved.
*/


import Cocoa
import EverydayWallpaperUtils

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    var defaultToolTipDelay: Int = 0
    var reach: Reachability?
    
    let activity = NSBackgroundActivityScheduler(identifier: NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"] as! String)
    

    func applicationDidFinishLaunching(notification: NSNotification) {
        self.reach = Reachability.reachabilityForInternetConnection()
        
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = Selector("togglePopover:")
        }

        popover.contentViewController = EverydayWallpaperViewController(nibName: "EverydayWallpaperViewController", bundle: nil)

        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) {
            [unowned self] event in
            if self.popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()

        self.saveAndChangeDefaultToolTipDefaults()
        
        self.checkWallpaperUpdate()

    }
    

    func applicationWillTerminate(aNotification: NSNotification) {
        self.restoreDefaultToolTipDefaults()
        self.reach?.stopNotifier()
        self.activity.invalidate()
    }
    
    func scheduleNextUpdate() {
       //BackgroundTaskScheduler.delay(<#T##time: NSTimeInterval##NSTimeInterval#>, task: <#T##() -> ()#>)
    }


    func checkWallpaperUpdate()
    {
        if AppSettings.sharedInstance.IsActivate {
         //   if AppSettings.sharedInstance.LastSuccessfulUpdate.isToday() == false || 1==1 {
           //     wallpaperUpdate()
          //  }
           // else {
           // }
        }
    }
    
    func wallpaperUpdate()
    {
        let todayWallpaper = BingWallpaperService.GetTodayBingWallpaperReference(AppSettings.sharedInstance.MainCodePage)
        var alternateWallpaper = todayWallpaper
        
        
        var naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: ScreenInfo.screensSizeFromIndex(0), withDate: NSDate(), withMarket: AppSettings.sharedInstance.MainCodePage)
        
        ImageDownloader.sharedLoader.downloadImageFromUrl(todayWallpaper!.Url, fileName: naming.fileName())
        
        let success: Bool = NSFileManager.defaultManager().fileExistsAtPath(naming.fullName())
        
        if (success) {
            do {
                let imgurl = NSURL.fileURLWithPath(naming.fullName())
                let workspace = NSWorkspace.sharedWorkspace()
                if let screen = NSScreen.mainScreen()  {
                    

                    try workspace.setDesktopImageURL(imgurl, forScreen: screen, options: [:])
                }
                
            } catch {
                print(error)
            }
        }

        if (true == true) {
            alternateWallpaper = BingWallpaperService.GetTodayBingWallpaperReference(AppSettings.sharedInstance.AlternateCodePage)
            
            
            naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: ScreenInfo.screensSizeFromIndex(0), withDate: NSDate(), withMarket: AppSettings.sharedInstance.AlternateCodePage)
            
            ImageDownloader.sharedLoader.downloadImageFromUrl(alternateWallpaper!.Url, fileName: naming.fileName())
        }

        do {
            let imgurl = NSURL.fileURLWithPath(naming.fullName())
            let workspace = NSWorkspace.sharedWorkspace()
            if let screen = NSScreen.screens()?.last  {
            
                    try workspace.setDesktopImageURL(imgurl, forScreen: screen, options: [:])
                }
                
            } catch {
                print(error)
            }
        
        
        
        

        /*
        let bing = BingWallpaperService.GetYesterdayBingWallpaperReference(DefaultMarket)
        
        var mainScreenResolution = bing!.resolutionFromSize(ScreenInfo.mainScreenSize())
        let url = bing!.urlStringByAppendingResolution(mainScreenResolution)
        
        let downloadedImagePath = ImageDownloader.sharedLoader.downloadImageFromUrl(url, fileName: "test\(resolution).jpg")
        
        let success: Bool = NSFileManager.defaultManager().fileExistsAtPath("\(downloadedImagePath)")
        
        XCTAssert(success, "Downloaded wallpaper for resolution \(resolution) error")
        
        if success {
        do {
        try NSFileManager.defaultManager().removeItemAtPath("\(downloadedImagePath)")
        } catch {
        XCTAssert(false, "Error deleting file for resolution \(resolution)")
        }
        }
        }*/
    }

    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        eventMonitor?.start()
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

    // check if nework unavailable and call reachabilityChanged when network become available
    func isWaitingForNextReachNeeded() -> Bool {
        if !self.reach!.isReachableViaWiFi() && !self.reach!.isReachableViaWWAN() {
            self.updateWallpaperOnNextNetworkConnect()
            
            return true;
        }
        else {
            return false;
        }
    }
    
    
    func updateWallpaperOnNextNetworkConnect () {
        // Allocate a reachability object
        self.reach = Reachability.reachabilityForInternetConnection()
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        self.reach!.reachableOnWWAN = false
        
        // Here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reachabilityChanged:",
            name: kReachabilityChangedNotification,
            object: nil)
        
        self.reach!.startNotifier()
    }
    
    func reachabilityChanged(notification: NSNotification) {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            print("Service avalaible!!!")
            self.reach!.stopNotifier()
        }
    }
    
    private func saveAndChangeDefaultToolTipDefaults() {
        defaultToolTipDelay = NSUserDefaults.standardUserDefaults().integerForKey("NSInitialToolTipDelay")

        NSUserDefaults.standardUserDefaults().setInteger(100, forKey: "NSInitialToolTipDelay")
    }

    private func restoreDefaultToolTipDefaults() {
        NSUserDefaults.standardUserDefaults().setInteger(defaultToolTipDelay, forKey: "NSInitialToolTipDelay")
    }
    
    private func loadScheduler() {
        
    }
}


/*
import Foundation

let baseUrl = "http://www.bing.com/"
let relativeUrl = "HPImageArchive.aspx?format=js&mbl=1&idx=0&n=1&mkt=zh-CN"

var endpoint = NSURL(string: baseUrl.stringByAppendingString(relativeUrl))
var data = NSData(contentsOfURL: endpoint!)

do {
let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary

let imgUrl = jsonDictionary.valueForKeyPath("images.url") as! [String]
let imgUrlBase = jsonDictionary.valueForKeyPath("images.urlbase") as! [String]
let startDate = jsonDictionary.valueForKeyPath("images.startdate") as! [String]
let endDate = jsonDictionary.valueForKeyPath("images.enddate") as! [String]

let bing = BingWallpaper(url: baseUrl.stringByAppendingString(imgUrl[0]),
urlBase: baseUrl.stringByAppendingString(imgUrlBase[0]),
startDate: startDate[0],
endDate: endDate[0])

print(bing.Url)
print(bing.UrlWithoutResolution)
print(bing.StartDate)
print(bing.EndDate)

} catch let error {
print("JSON Serialization failed. Error: \(error)")
}

import Foundation

let baseUrl = "http://www.bing.com/"
let relativeUrl = "HPImageArchive.aspx?format=js&mbl=1&idx=0&n=1&mkt=zh-CN"

var endpoint = NSURL(string: baseUrl.stringByAppendingString(relativeUrl))
var data = NSData(contentsOfURL: endpoint!)

do {
let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary

let imgUrl = jsonDictionary.valueForKeyPath("images.url") as! [String]
let imgUrlBase = jsonDictionary.valueForKeyPath("images.urlbase") as! [String]
let startDate = jsonDictionary.valueForKeyPath("images.startdate") as! [String]
let endDate = jsonDictionary.valueForKeyPath("images.enddate") as! [String]

let bing = BingWallpaper(url: baseUrl.stringByAppendingString(imgUrl[0]),
urlBase: baseUrl.stringByAppendingString(imgUrlBase[0]),
startDate: startDate[0],
endDate: endDate[0])

print(bing.Url)
print(bing.UrlWithoutResolution)
print(bing.StartDate)
print(bing.EndDate)

} catch let error {
print("JSON Serialization failed. Error: \(error)")
}


*/