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

    func testKeep0Day()
    {
        self.deleteAllFilesHelper()

        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-13 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-03 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-27 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishAustralia.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishNewZealand.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2000-12-15 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)

        XCTAssert(SearchFile.listOfFileToDelete(ImageDownloader.sharedLoader.WallpaperSavePath, keepFileCount: 0).count == 10, "Keep 0 day fail")

        deleteAllFilesHelper()
    }

    func testKeep1Day()
    {
        self.deleteAllFilesHelper()

        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-13 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-03 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-27 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishAustralia.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishNewZealand.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2000-12-15 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)

        XCTAssert(SearchFile.listOfFileToDelete(ImageDownloader.sharedLoader.WallpaperSavePath, keepFileCount: 1).count == 8, "Keep 1 day fail")

        deleteAllFilesHelper()
    }

    func testKeep2Day()
    {
        self.deleteAllFilesHelper()

        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-13 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-03 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-27 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishAustralia.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishNewZealand.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2000-12-15 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)

        XCTAssert(SearchFile.listOfFileToDelete(ImageDownloader.sharedLoader.WallpaperSavePath, keepFileCount: 2).count == 7, "Keep 2 day fail")

        deleteAllFilesHelper()
    }

    func testKeep3Day()
    {
        self.deleteAllFilesHelper()

        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-13 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-03 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-27 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishAustralia.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishNewZealand.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2000-12-15 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)

        XCTAssert(SearchFile.listOfFileToDelete(ImageDownloader.sharedLoader.WallpaperSavePath, keepFileCount: 3).count == 6, "Keep 3 day fail")

        deleteAllFilesHelper()
    }

    func testKeep4Day()
    {
        self.deleteAllFilesHelper()

        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-13 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-03 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-27 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishAustralia.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishNewZealand.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2000-12-15 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)

        XCTAssert(SearchFile.listOfFileToDelete(ImageDownloader.sharedLoader.WallpaperSavePath, keepFileCount: 4).count == 5, "Keep 4 day fail")

        deleteAllFilesHelper()
    }

    func testKeep5Day()
    {
        self.deleteAllFilesHelper()

        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-13 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-03 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-27 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishAustralia.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishNewZealand.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2000-12-15 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)

        XCTAssert(SearchFile.listOfFileToDelete(ImageDownloader.sharedLoader.WallpaperSavePath, keepFileCount: 5).count == 1, "Keep 5 day fail")

        deleteAllFilesHelper()
    }

    func testKeep6Day()
    {
        self.deleteAllFilesHelper()

        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-13 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-03 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-27 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishAustralia.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishNewZealand.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2000-12-15 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)

        XCTAssert(SearchFile.listOfFileToDelete(ImageDownloader.sharedLoader.WallpaperSavePath, keepFileCount: 6).count == 0, "Keep 6 day fail")

        deleteAllFilesHelper()
    }

    func testKeep99Day()
    {
        self.deleteAllFilesHelper()

        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-19 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-13 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-03-03 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-27 06:00:00"), market: BingWallperMarkets.JapaneseJapan.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishAustralia.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishCanada.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishNewZealand.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2016-02-24 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)
        createFakeWallpaperFileHelper(NSDate(dateString: "2000-12-15 06:00:00"), market: BingWallperMarkets.EnglishUnitedKingdom.rawValue)

        XCTAssert(SearchFile.listOfFileToDelete(ImageDownloader.sharedLoader.WallpaperSavePath, keepFileCount: 99).count == 0, "Keep 99 day fail")

        deleteAllFilesHelper()
    }
    // Utility function
    func createFakeWallpaperFileHelper(date: NSDate, market: String)
    {
        let naming = WallpaperFiles.init(provider: WallpaperFiles.BingProvider, withBaseFolder: ImageDownloader.sharedLoader.WallpaperSavePath, withSize: CGSizeMake(1024, 768), withDate: date, withMarket: market)

        let content = "for exist test file"

        let fileName = naming.fullName(date)
        content.toFile(fileName)
    }

    // Utility function
    func deleteAllFilesHelper()
    {
        let keys = [NSURLIsDirectoryKey, NSURLLocalizedNameKey]
        let validateWallpaper = "\(Constants.Naming.FileNameSeparator)\(Constants.Naming.Bing)\(Constants.Naming.FileNameSeparator)"

        do
        {
            let directoryUrls = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(NSURL(fileURLWithPath: ImageDownloader.sharedLoader.WallpaperSavePath), includingPropertiesForKeys: keys, options: .SkipsHiddenFiles)

            let urls = directoryUrls.filter
            {
                $0.pathExtension == "jpg"
            }.map
            {
                $0
            }.sort({ $0.lastPathComponent > $1.lastPathComponent })


            for url in urls
            {
                do
                {
                    let resourceValues = try url.resourceValuesForKeys(keys)

                    if let isDirectory = resourceValues[NSURLIsDirectoryKey] as? NSNumber
                    {
                        if !isDirectory.boolValue
                        {
                            if url.lastPathComponent!.rangeOfString(validateWallpaper) != nil
                            {
                                if url.lastPathComponent![0 ... 7].isValidShortDateString()
                                {
                                    try NSFileManager.defaultManager().removeItemAtURL(url)
                                }
                            }
                        }
                    }

                }
                catch
                {
                }
            }
        }
        catch
        {
        }
    }
}
