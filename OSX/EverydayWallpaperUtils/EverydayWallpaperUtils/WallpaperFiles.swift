//
//  WallpaperFiles.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 05.01.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import Foundation
import Cocoa

public class WallpaperFiles {
    var BaseFolder: String = ""
    var Market: String = "none"
    var WallpaperProvider: String = ""
    var Width: Int = 0
    var Height: Int = 0
    var Date: NSDate

    public init() {
        self.BaseFolder = ""
        self.Width = Int(0)
        self.Height = Int(0)
        self.WallpaperProvider = ""
        self.Date = NSDate()
        self.Market = "none"
    }

    public convenience init(provider: String) {
        self.init()
        self.WallpaperProvider = provider
    }

    public convenience init(provider: String, withBaseFolder: String) {
        self.init(provider: provider)

        self.BaseFolder = withBaseFolder
    }
    
    public convenience init(provider: String, withBaseFolder: String, withSize: CGSize) {
        self.init(provider: provider, withBaseFolder: withBaseFolder)
        
        self.Width = Int(withSize.width)
        self.Height = Int(withSize.height)
    }
    
    public convenience init(provider: String, withBaseFolder: String, withSize: CGSize, withDate: NSDate) {
        self.init(provider: provider, withBaseFolder: withBaseFolder, withSize: withSize)
        
        self.Date = withDate
    }

    public convenience init(provider: String, withBaseFolder: String, withSize: CGSize, withDate: NSDate, withMarket: String) {
        self.init(provider: provider, withBaseFolder: withBaseFolder, withSize: withSize, withDate: withDate)
        
        self.Market = withMarket
    }
    
    public func fullName() -> String {
        let destinationPath = NSURL.init(fileURLWithPath: ImageDownloader.sharedLoader.WallpaperSavePath).URLByAppendingPathComponent("\(self.fileName())")
        
        return destinationPath.path!
    }

    public func fullName(withDate: NSDate) -> String {
        let destinationPath = NSURL.init(fileURLWithPath: ImageDownloader.sharedLoader.WallpaperSavePath).URLByAppendingPathComponent("\(self.fileName(withDate))")
        
        return destinationPath.path!
    }
    
    public func fileName() -> String {
        
        return "\(Date.toShortString())-\(WallpaperProvider)-\(Market)-\(Width)x\(Height).jpg"
    }

    public func fileName(withDate: NSDate) -> String {
        return "\(withDate.toShortString())-\(WallpaperProvider)-\(Market)-\(Width)x\(Height).jpg"
    }
    
    public func fileExist() -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath("\(self.fullName())")
    }
    
    public func fileExist(withDate: NSDate) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath("\(self.fullName(withDate))")
    }
    
    public static var BingProvider: String {
        get {
            return "Bing"
        }
    }

    /// unused
    public static var NationalGeogrphicProvider: String {
        get {
            return "Bing"
        }
    }
}