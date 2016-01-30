//
//  WallpaperFilesTest.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 27.01.16.
//  Copyright © 2016 Hugo PEREIRA. All rights reserved.
//

import XCTest

@testable import EverydayWallpaperUtils

class WallpaperFilesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNaming() {
        let dateFrom = NSDate(dateString:"2010-12-15 06:00:00")
        
        let naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: CGSizeMake(1024, 768), withDate: dateFrom)
        
        XCTAssert(naming.fullName() == "\(ImageDownloader.sharedLoader.WallpaperSavePath)/20101215\(Constants.Naming.FileNameSeparator)\(Constants.Naming.Bing)\(Constants.Naming.FileNameSeparator)\(Constants.Default.None)\(Constants.Naming.FileNameSeparator)1024\(Constants.Naming.ResolutionSeparator)768.jpg" , "Wallpaper URL malformed")
    }

    func testExistForDate() {
        let dateFrom = NSDate(dateString:"2001-12-15 06:00:00")
        
        let naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: CGSizeMake(1024, 768), withDate: dateFrom)
        
        let content = "for exist test file"
        
        let fileName = naming.fullName(dateFrom)
        
        content.toFile(fileName)
        
        XCTAssert(naming.fileExist(dateFrom), "Wallpaper file exist fail")
        
        do {
            try NSFileManager.defaultManager().removeItemAtPath(fileName)
            
        }
        catch {
            XCTAssert(false, "Wallpaper file not exit exist fail")
        }
    }
}
