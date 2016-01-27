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
        
        XCTAssert(naming.fullName() == "\(ImageDownloader.sharedLoader.WallpaperSavePath)/20101215-Bing-none-1024x768.jpg" , "Wallpaper URL malformed")
    }

}
