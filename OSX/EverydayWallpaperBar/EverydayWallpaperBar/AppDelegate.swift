/*
* Created by Hugo PEREIRA
* Copyright © 2015 Hugo PEREIRA. All rights reserved.
*/


import Cocoa

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
        
        self.activity.tolerance = 60
        self.activity.interval = 3600
        self.activity.repeats = true
        
        activity.scheduleWithBlock(
            { (completion: NSBackgroundActivityCompletionHandler) in
                self.checkWallpaperUpdate()
                completion(NSBackgroundActivityResult.Finished)
            }
        )

    }

    func applicationWillTerminate(aNotification: NSNotification) {
        self.activity.invalidate()
        self.restoreDefaultToolTipDefaults()
        self.reach?.stopNotifier()
    }

    func checkWallpaperUpdate()
    {
        if AppSettings.sharedInstance.IsActivate {
            
            if !AppSettings.sharedInstance.LastSuccessfulUpdate.isToday() {
                
            }
            
            
        }
    }
    
    func wallpaperUpdate()
    {
        
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