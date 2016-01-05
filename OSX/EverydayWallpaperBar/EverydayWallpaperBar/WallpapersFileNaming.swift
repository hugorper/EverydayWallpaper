//
//  WallpapersFileNaming.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 05.01.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import Foundation


class WallpapersFileNameing {
    var BaseFolder: String
    var WallpaperProvider: String
    var Width: Int = 0
    var Height: Int = 0
    var Date: NSDate
    
    init(wallpaperProvider: String) {
        self.WallpaperProvider = wallpaperProvider
    }

    init(wallpaperProvider: String, withBaseFolder: String) {
        self.init(wallpaperProvider)
        
        self.BaseFolder = baseFolder
    }
    
    init(wallpaperProvider: String, withBaseFolder: String, withSize: GCFloat) {
        self.init(wallpaperProvider, withBaseFolder)
        
        self.Width = Int(size.Width)
        self.Height = Int(size.Height)
    }
    
    init(wallpaperProvider: String, withBaseFolder: String, withSize: GCFloat, withDate: NSDate) {
        self.init(wallpaperProvider, withBaseFolder, withSize)
        
        self.Date = withDate
    }
    
    func fullName() -> String {
        return ""
    }

    func fileName() -> String {
        return ""
    }
    
    func fileExist() -> Bool {
        return false
    }

}