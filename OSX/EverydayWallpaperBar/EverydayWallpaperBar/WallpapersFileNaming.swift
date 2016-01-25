//
//  WallpapersFileNaming.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 05.01.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import Foundation
import Cocoa
import EverydayWallpaperUtils

class WallpapersFileNaming {
    var BaseFolder: String = ""
    var Market: String = "none"
    var WallpaperProvider: String = ""
    var Width: Int = 0
    var Height: Int = 0
    var Date: NSDate

    init() {
        self.BaseFolder = ""
        self.Width = Int(0)
        self.Height = Int(0)
        self.WallpaperProvider = ""
        self.Date = NSDate()
        self.Market = ""
    }

    convenience init(provider: String) {
        self.init()
        self.WallpaperProvider = provider
    }

    convenience init(provider: String, withBaseFolder: String) {
        self.init(provider: provider)

        self.BaseFolder = withBaseFolder
    }
    
    convenience init(provider: String, withBaseFolder: String, withSize: CGSize) {
        self.init(provider: provider, withBaseFolder: withBaseFolder)
        
        self.Width = Int(withSize.width)
        self.Height = Int(withSize.height)
    }
    
    convenience init(provider: String, withBaseFolder: String, withSize: CGSize, withDate: NSDate) {
        self.init(provider: provider, withBaseFolder: withBaseFolder, withSize: withSize)
        
        self.Date = withDate
    }

    convenience init(provider: String, withBaseFolder: String, withSize: CGSize, withDate: NSDate, withMarket: String) {
        self.init(provider: provider, withBaseFolder: withBaseFolder, withSize: withSize, withDate: withDate)
        
        self.Market = withMarket
    }
    
    func fullName() -> String {
        let destinationPath = NSURL.init(fileURLWithPath: ImageDownloader.sharedLoader.WallpaperSavePath).URLByAppendingPathComponent("\(self.fileName())")
        
        return destinationPath.path!
    }

    func fileName() -> String {
        
        return "\(Date.toShortString())-\(WallpaperProvider)-\(Market)-\(Width)x\(Height).jpg"
    }
    
    func fileExist() -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath("\(self.fullName())")
    }
    
    static var BingProvider: String {
        get {
            return "Bing"
        }
    }

    /// unused
    static var NationalGeogrphicProvider: String {
        get {
            return "Bing"
        }
    }
}