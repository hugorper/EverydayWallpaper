//
//  ScreenInfo.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 04.01.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import Foundation
import Cocoa

class ScreenInfo {

    static internal func screensCount() -> Int {
        return (NSScreen.screens()?.count)!
    }
    
    static internal func mainScreenSize() -> CGSize {
        // screen index 0 is always the main screen
        return self.screensSizeFromIndex(0)
    }
    
    static internal func screensSizeFromIndex(zeroBasedIndex: Int) -> CGSize {
        let screen: NSScreen = NSScreen.screens()![zeroBasedIndex]
        let description: NSDictionary = screen.deviceDescription
        let displayPixelSize: NSSize = description.objectForKey(NSDeviceSize)!.sizeValue
        
        return CGSizeMake(displayPixelSize.width, displayPixelSize.height)
    }
}
