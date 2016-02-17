//
//  SearchFileTests.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 28.01.16.
//  Copyright © 2016 Hugo PEREIRA. All rights reserved.
//

import XCTest

@testable import EverydayWallpaperUtils

class SearchFileTests: XCTestCase
{

    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown()
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFileExist()
    {
        let dateFrom = NSDate(dateString: "2000-12-15 06:00:00")

        let naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: CGSizeMake(1024, 768), withDate: dateFrom)

        let content = "for exist test file"

        let fileName = naming.fullName(dateFrom)

        content.toFile(fileName)

        XCTAssert(SearchFile.existFromDirectory(ImageDownloader.sharedLoader.WallpaperSavePath, withPrefix: "20001215"), "File not found")

        do
        {
            try NSFileManager.defaultManager().removeItemAtPath(fileName)

        }
        catch
        {
            XCTAssert(false, "Wallpaper file not exit exist fail")
        }
    }

    func testFileNotExist()
    {
        let dateFrom = NSDate(dateString: "2000-12-15 06:00:00")

        let naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: CGSizeMake(1024, 768), withDate: dateFrom)

        let content = "for exist test file"

        let fileName = naming.fullName(dateFrom)

        content.toFile(fileName)

        XCTAssert(SearchFile.existFromDirectory(ImageDownloader.sharedLoader.WallpaperSavePath, withPrefix: "2000121a") == false, "File found")

        do
        {
            try NSFileManager.defaultManager().removeItemAtPath(fileName)

        }
        catch
        {
            XCTAssert(false, "Wallpaper file not exit exist fail")
        }
    }

}
