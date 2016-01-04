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
        return self.screensSizeFromIndex(0)
    }

    
    static internal func screensSizeFromIndex(zeroBasedIndex: Int) -> CGSize {
        let screen: NSScreen = NSScreen.screens()![zeroBasedIndex]
        let description: NSDictionary = screen.deviceDescription
        let displayPixelSize: NSSize = description.objectForKey(NSDeviceSize)!.sizeValue
        
        return CGSizeMake(displayPixelSize.width, displayPixelSize.height)
    }
    
    
    
    static internal func makeSizeFromCentimeters(width: CGFloat, height: CGFloat) -> CGSize {
        
        let screen: NSScreen = NSScreen.mainScreen()!
        
        let description: NSDictionary = screen.deviceDescription
        let displayPixelSize: NSSize = description.objectForKey(NSDeviceSize)!.sizeValue
        let displayPhysicalSize: CGSize = CGDisplayScreenSize(description.objectForKey("NSScreenNumber")!.unsignedIntValue)
        let resolution = (displayPixelSize.width / displayPhysicalSize.width) * 25.4
        
        let pixelsWidth: CGFloat = 0.394 * width * resolution
        let pixelsHeight: CGFloat = 0.394 * height * resolution
        
        return CGSizeMake(pixelsWidth, pixelsHeight)
        
    }
}
