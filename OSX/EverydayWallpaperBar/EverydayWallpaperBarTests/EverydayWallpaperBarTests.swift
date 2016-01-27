//
//  EverydayWallpaperAppSettingsTests.swift
//  EverydayWallpaperAppSettingsTests
//
//  Created by Hugo PEREIRA on 31.12.15.
//  Copyright © 2015 Hugo Pereira. All rights reserved.
//

import XCTest
@testable import EverydayWallpaperBar

class EverydayWallpaperAppSettingsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        AppSettings.sharedInstance.reloadDefaultPreference()
        
        super.tearDown()
    }
    
    func testReloadDefaultSettingsFromFile() {
        AppSettings.sharedInstance.IsActivate = false
        
        AppSettings.sharedInstance.reloadDefaultPreference()
        
        XCTAssert(AppSettings.sharedInstance.IsActivate == true, "Reload settings fail")
    }
    
    func testRemoveSettings() {
        AppSettings.sharedInstance.deleteAllPreference()
        
        XCTAssert(AppSettings.sharedInstance.isFirstUse(), "Preferences not deleted")
    }
    
    func testIsWallpaperSavedReadWrite() {
        let testValue1 = true
        let testValue2 = false
        
        AppSettings.sharedInstance.IsWallpaperSaved = testValue1
        XCTAssert(AppSettings.sharedInstance.IsWallpaperSaved == testValue1, "Value error for IsWallpaperSaved")
        
        AppSettings.sharedInstance.IsWallpaperSaved = testValue2
        XCTAssert(AppSettings.sharedInstance.IsWallpaperSaved == testValue2)
    }
    
    func testIsActivateReadWrite() {
        let testValue1 = true
        let testValue2 = false
        
        AppSettings.sharedInstance.IsActivate = testValue1
        XCTAssert(AppSettings.sharedInstance.IsActivate == testValue1, "Value error for IsActivate")
        
        AppSettings.sharedInstance.IsActivate = testValue2
        XCTAssert(AppSettings.sharedInstance.IsActivate == testValue2)
    }
    
    func testMainCodePageReadWrite() {
        let testValue1 = "abc"
        let testValue2 = "wxyz"
        
        AppSettings.sharedInstance.MainCodePage = testValue1
        XCTAssert(AppSettings.sharedInstance.MainCodePage == testValue1, "Value error for MainCodePage")
        
        AppSettings.sharedInstance.MainCodePage = testValue2
        XCTAssert(AppSettings.sharedInstance.MainCodePage == testValue2)
    }
    
    func testAlternateCodePageReadWrite() {
        let testValue1 = "abc"
        let testValue2 = "wxyz"
        
        AppSettings.sharedInstance.AlternateCodePage = testValue1
        XCTAssert(AppSettings.sharedInstance.AlternateCodePage == testValue1, "Value error for AlternateCodePage")
        
        AppSettings.sharedInstance.AlternateCodePage = testValue2
        XCTAssert(AppSettings.sharedInstance.AlternateCodePage == testValue2)
    }
    
    func testIsAlternateIsDifferentReadWrite() {
        let testValue1 = true
        let testValue2 = false
        
        AppSettings.sharedInstance.IsAlternateIsDifferent = testValue1
        XCTAssert(AppSettings.sharedInstance.IsAlternateIsDifferent == testValue1, "Value error for IsAlternateIsDifferent")
        
        AppSettings.sharedInstance.IsAlternateIsDifferent = testValue2
        XCTAssert(AppSettings.sharedInstance.IsAlternateIsDifferent == testValue2)
    }
    
    func testIsAlternateUseYesterdayWallpaperReadWrite() {
        let testValue1 = true
        let testValue2 = false
        
        AppSettings.sharedInstance.IsAlternateUseYesterdayWallpaper = testValue1
        XCTAssert(AppSettings.sharedInstance.IsAlternateUseYesterdayWallpaper == testValue1, "Value error for IsAlternateUseYesterdayWallpaper")
        
        AppSettings.sharedInstance.IsAlternateUseYesterdayWallpaper = testValue2
        XCTAssert(AppSettings.sharedInstance.IsAlternateUseYesterdayWallpaper == testValue2)
    }
    
}


