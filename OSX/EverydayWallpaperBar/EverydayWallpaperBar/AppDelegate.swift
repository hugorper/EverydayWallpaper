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
  private var defaultToolTipDelay: Int = 0


  func applicationDidFinishLaunching(notification: NSNotification) {
    if let button = statusItem.button {
      button.image = NSImage(named: "StatusBarButtonImage")
      button.action = Selector("togglePopover:")
    }

    popover.contentViewController = EverydayWallpaperViewController(nibName: "EverydayWallpaperViewController", bundle: nil)
    
    eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
      if self.popover.shown {
        self.closePopover(event)
      }
    }
    eventMonitor?.start()
    
    self.saveAndChangeDefaultToolTipDefaults()

  }

    func applicationWillTerminate(aNotification: NSNotification) {
        self.restoreDefaultToolTipDefaults()
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
    
    private func saveAndChangeDefaultToolTipDefaults() {
        defaultToolTipDelay = NSUserDefaults.standardUserDefaults().integerForKey("NSInitialToolTipDelay")
        
        NSUserDefaults.standardUserDefaults().setInteger(100, forKey: "NSInitialToolTipDelay")
    }
    
    private func restoreDefaultToolTipDefaults() {
        NSUserDefaults.standardUserDefaults().setInteger(defaultToolTipDelay, forKey: "NSInitialToolTipDelay")
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