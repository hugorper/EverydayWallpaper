//
//  EverydayWallpaperUtilsTests.swift
//  EverydayWallpaperUtilsTests
//
//  Created by Hugo PEREIRA on 04.12.15.
//  Copyright © 2015 Hugo PEREIRA. All rights reserved.
//

import XCTest

@testable import EverydayWallpaperUtils

class EverydayWallpaperUtilsTests: XCTestCase {
    
    let DefaultMarket: String = "en-US";
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBingWallpaperDate() {
        //Get Current Date/Time
        let currentDateTime = NSDate()
        let daysToAdd: NSTimeInterval = -5
        
        //Date (which is Due date minus 5 days)
        let fiveDaysBefore = currentDateTime.dateByAddingTimeInterval(60*60*24*daysToAdd)
        
        let bing = BingWallpaperService.GetTodayBingWallpaperReference(DefaultMarket);
        
        
        XCTAssert(bing?.StartDate.compare(fiveDaysBefore) == NSComparisonResult.OrderedDescending, "Invalid date")
    }
    
    func testUrlLoaded() {
        let bing = BingWallpaperService.GetTodayBingWallpaperReference(DefaultMarket);
        XCTAssert(bing?.Url.characters.count > 0, "Wallpaper URL empty")
    }
    
    func testAllMarkets() {
        for market in BingWallperMarkets.allValues {
            let bing = BingWallpaperService.GetTodayBingWallpaperReference(market.rawValue);
            XCTAssert(bing?.Url.characters.count > 0, "Market wallpaper \(market) not found")
        }
    }

    func testAllResolutionsDownloadWithPerformance() {
        //let bing = BingWallpaperService.GetTodayBingWallpaperReference(DefaultMarket);
        let bing = BingWallpaperService.GetYesterdayBingWallpaperReference(DefaultMarket);

        for resolution in BingWallperResolutions.allValues {
            
            let url = bing!.urlStringByAppendingResolution(resolution)
            
            let downloadedImagePath = ImageDownloader.sharedLoader.downloadImageFromUrl(url, fileName: "test\(resolution).jpg")
            
            let success: Bool = NSFileManager.defaultManager().fileExistsAtPath("\(downloadedImagePath)")
            
            XCTAssert(success, "Downloaded wallpaper for resolution \(resolution) error")
            
            if success {
                do {
                    try NSFileManager.defaultManager().removeItemAtPath("\(downloadedImagePath)")
                } catch {
                    XCTAssert(false, "Error deleting file for resolution \(resolution)")
                }
            }
        }
    }
    
    func testBingWallpaperPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            _ = BingWallpaperService.GetTodayBingWallpaperReference(self.DefaultMarket);
        }
    }
    
}
