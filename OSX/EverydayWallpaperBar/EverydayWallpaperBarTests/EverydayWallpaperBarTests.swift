//
//  EverydayWallpaperAppSettingsTests.swift
//  EverydayWallpaperAppSettingsTests
//
//  Created by Hugo PEREIRA on 31.12.15.
//  Copyright © 2015 Hugo Pereira. All rights reserved.
//

import XCTest
import XCGLogger
@testable import EverydayWallpaperBar

class EverydayWallpaperAppSettingsTests: XCTestCase
{

    override func setUp()
    {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown()
    {
        AppSettings.sharedInstance.reloadDefaultPreference()

        super.tearDown()
    }

    func testReloadDefaultSettingsFromFile()
    {
        AppSettings.sharedInstance.IsActivate = false

        AppSettings.sharedInstance.reloadDefaultPreference()

        XCTAssert(AppSettings.sharedInstance.IsActivate == true, "Reload settings fail")
    }

    func testRemoveSettings()
    {
        AppSettings.sharedInstance.deleteAllPreference()

        XCTAssert(AppSettings.sharedInstance.isFirstUse(), "Preferences not deleted")
    }

    func testIsWallpaperSavedReadWrite()
    {
        let testValue1 = true
        let testValue2 = false

        AppSettings.sharedInstance.IsWallpaperSaved = testValue1
        XCTAssert(AppSettings.sharedInstance.IsWallpaperSaved == testValue1, "Value error for IsWallpaperSaved")

        AppSettings.sharedInstance.IsWallpaperSaved = testValue2
        XCTAssert(AppSettings.sharedInstance.IsWallpaperSaved == testValue2)
    }

    func testIsActivateReadWrite()
    {
        let testValue1 = true
        let testValue2 = false

        AppSettings.sharedInstance.IsActivate = testValue1
        XCTAssert(AppSettings.sharedInstance.IsActivate == testValue1, "Value error for IsActivate")

        AppSettings.sharedInstance.IsActivate = testValue2
        XCTAssert(AppSettings.sharedInstance.IsActivate == testValue2)
    }

    func testMainCodePageReadWrite()
    {
        let testValue1 = "abc"
        let testValue2 = "wxyz"

        AppSettings.sharedInstance.MainCodePage = testValue1
        XCTAssert(AppSettings.sharedInstance.MainCodePage == testValue1, "Value error for MainCodePage")

        AppSettings.sharedInstance.MainCodePage = testValue2
        XCTAssert(AppSettings.sharedInstance.MainCodePage == testValue2)
    }

    func testReadBingUpdateHoursWithMarket()
    {
        XCTAssert(AppSettings.sharedInstance.getBingUpdateHoursWithMarket("en-US").characters.count > 3, "Could not read time from market")
    }

    func testWriteBingUpdateHoursWithMarket()
    {
        let market = "en-US"
        let restoreInitialValue = AppSettings.sharedInstance.getBingUpdateHoursWithMarket(market)

        AppSettings.sharedInstance.setBingUpdateHoursWithMarket(market, withTimeString: "none")
        XCTAssert(AppSettings.sharedInstance.getBingUpdateHoursWithMarket(market) == "none", "Could not write and save time to market")

        // restore initial value
        AppSettings.sharedInstance.setBingUpdateHoursWithMarket(market, withTimeString: restoreInitialValue)

        XCTAssert(AppSettings.sharedInstance.getBingUpdateHoursWithMarket("en-US").characters.count > 3, "Could not read time from market")
    }

    func testLogLevelReadWrite()
    {
        AppSettings.sharedInstance.LogLevel = XCGLogger.LogLevel.None
        XCTAssert(AppSettings.sharedInstance.LogLevel == XCGLogger.LogLevel.None, "Log level error, not the same as saved")

        AppSettings.sharedInstance.LogLevel = XCGLogger.LogLevel.Severe
        XCTAssert(AppSettings.sharedInstance.LogLevel == XCGLogger.LogLevel.Severe, "Log level error, not the same as saved")
    }


    func testLogFilePathLog()
    {
        let logFilePath = "\(LogFilePathUtilHelper.UserLibraryLogFilePathForApp("EverydayWallpaper"))testlog.log"
        let log = XCGLogger.defaultInstance()

        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logFilePath, fileLogLevel: .Debug)

        log.info("Test log file")

        let success: Bool = NSFileManager.defaultManager().fileExistsAtPath(logFilePath)

        XCTAssert(success, "Log file not created")

        if success
        {
            do
            {
                try NSFileManager.defaultManager().removeItemAtPath(logFilePath)
            }
            catch
            {
                XCTAssert(false, "Error deleting log file")
            }
        }
    }
    /*
    func testIsUpdatedToday()
    {
        var isUpdatedToday = false
        var shortDateString = NSDate().toShortString()
        shortDateString.appendContentsOf(Constants.Naming.FileNameSeparator)
        
        if SearchFile.existFromDirectory(ImageDownloader.sharedLoader.WallpaperSavePath, withPrefix: shortDateString)
        {
            isUpdatedToday = true
        }
        
        return isUpdatedToday;
    }*/

}


