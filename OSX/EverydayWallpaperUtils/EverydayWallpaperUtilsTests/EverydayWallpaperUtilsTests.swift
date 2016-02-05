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

    let DefaultMarket: String = "en-US"

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
        let fiveDaysBefore = currentDateTime.dateByAddingTimeInterval(60 * 60 * 24 * daysToAdd)

        do {
            let bing = try BingWallpaperService.GetTodayBingWallpaperReference(DefaultMarket);
            XCTAssert(bing?.StartDate.compare(fiveDaysBefore) == NSComparisonResult.OrderedDescending, "Invalid date")
        }
        catch DownloadStatus.NetworkNotReachable {
            XCTAssert(false, "Network not reachable")
        }
        catch DownloadStatus.UndefinedError {
            XCTAssert(false, "Undifined error")
        }
        catch {
            XCTAssert(false, "Undifined error")
        }
    }

    func testUrlLoaded() {
        do {
            let bing = try BingWallpaperService.GetTodayBingWallpaperReference(DefaultMarket)
            XCTAssert(bing?.Url.characters.count > 0, "Wallpaper URL empty")
        }
        catch DownloadStatus.NetworkNotReachable {
            XCTAssert(false, "Network not reachable")
        }
        catch DownloadStatus.UndefinedError {
            XCTAssert(false, "Undifined error")
        }
        catch {
            XCTAssert(false, "Undifined error")
        }
    }

    func testAllMarkets() {
        do {
            for market in BingWallperMarkets.allValues {
                let bing = try BingWallpaperService.GetTodayBingWallpaperReference(market.rawValue);
                XCTAssert(bing?.Url.characters.count > 0, "Market wallpaper \(market) not found")
            }
        }
        catch DownloadStatus.NetworkNotReachable {
            XCTAssert(false, "Network not reachable")
        }
        catch DownloadStatus.UndefinedError {
            XCTAssert(false, "Undifined error")
        }
        catch {
            XCTAssert(false, "Undifined error")
        }
    }

    func testAllResolutionsDownloadWithPerformance() {
        do {
            let bing = try BingWallpaperService.GetYesterdayBingWallpaperReference(DefaultMarket)
            
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
        catch DownloadStatus.NetworkNotReachable {
            XCTAssert(false, "Network not reachable")
        }
        catch DownloadStatus.UndefinedError {
            XCTAssert(false, "Undifined error")
        }
        catch {
            XCTAssert(false, "Undifined error")
        }
    }
    
    func testBingWallpaperSizeMapper() {
        do {
            let bing = try BingWallpaperService.GetYesterdayBingWallpaperReference(DefaultMarket)
            let size = CGSizeMake(1024, 768)
            
            XCTAssert(bing!.resolutionFromSize(size) == BingWallperResolutions.Res1024x768, "Error resolution mao fail resolutionFromSize")
        }
        catch DownloadStatus.NetworkNotReachable {
            XCTAssert(false, "Network not reachable")
        }
        catch DownloadStatus.UndefinedError {
            XCTAssert(false, "Undifined error")
        }
        catch {
            XCTAssert(false, "Undifined error")
        }
     }

    func testBingWallpaperPerformance() {
        // This is an example of a performance test case.
        self.measureBlock {
            do {
                _ = try BingWallpaperService.GetTodayBingWallpaperReference(self.DefaultMarket)
            }
            catch DownloadStatus.NetworkNotReachable {
                XCTAssert(false, "Network not reachable")
            }
            catch DownloadStatus.UndefinedError {
                XCTAssert(false, "Undifined error")
            }
            catch {
                XCTAssert(false, "Undifined error")
            }
        }
    }

}
