//
//  AppLauncher.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 25.03.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import Cocoa
import Foundation
import ServiceManagement

public class AppLauncher
{
    public static func UpdateLoginItem(isLoginItemEnabled: Bool)
    {
        let launcherAppIdentifier = "com.hugorper.EverydayWallpaperLauncher"
        
        // this do the job
        SMLoginItemSetEnabled(launcherAppIdentifier, isLoginItemEnabled)
        
        var startedAtLogin = false
        for app in NSWorkspace.sharedWorkspace().runningApplications {
            if app.bundleIdentifier == launcherAppIdentifier {
                startedAtLogin = true
            }
        }
        
        if startedAtLogin {
            NSDistributedNotificationCenter.defaultCenter().postNotificationName("killme", object: NSBundle.mainBundle().bundleIdentifier!)
        }
    }
}