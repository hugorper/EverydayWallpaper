//
//  ScreenInfoTests.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 04.01.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import XCTest
@testable import EverydayWallpaperBar

class ScreenInfoTests: XCTestCase
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

    func testScreenCount()
    {
        XCTAssert(ScreenInfo.screensCount() >= 1, "Must return one or more screen countSize error")
    }


    func testMainScreenResolutionExample()
    {
        let size = ScreenInfo.mainScreenSize()

        XCTAssert(size.width > 100, "Size error")
        XCTAssert(size.height > 100, "Size error")
    }
}
