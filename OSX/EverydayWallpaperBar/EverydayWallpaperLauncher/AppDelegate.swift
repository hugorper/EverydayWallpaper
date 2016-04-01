//
//  AppDelegate.swift
//  EverydayWallpaperLauncher
//
//  Created by Hugo PEREIRA on 25.03.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        let mainAppIdentifier = "com.hugorper.EverydayWallpaperBar"
        let running           = NSWorkspace.sharedWorkspace().runningApplications
        var alreadyRunning    = false
        
        for app in running {
            if app.bundleIdentifier == mainAppIdentifier {
                alreadyRunning = true
                break
            }
        }
        
        if !alreadyRunning {
            NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector: "terminate", name: "killme", object: mainAppIdentifier)
            
            let path = NSBundle.mainBundle().bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("EverydayWallpaperBar") //main app name
            
            let newPath = NSString.pathWithComponents(components)
            
            NSWorkspace.sharedWorkspace().launchApplication(newPath)
        }
        else {
            self.terminate()
        }
    }
    
    func terminate() {
        //		NSLog("I'll be back!")
        NSApp.terminate(nil)
    }
    
}