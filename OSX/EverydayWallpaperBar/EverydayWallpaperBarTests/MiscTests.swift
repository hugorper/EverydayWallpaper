//
//  MiscTests.swift
//  EverydayWallpaperBar
//
//  Created by Hugo PEREIRA on 05.01.16.
//  Copyright © 2016 Hugo Pereira. All rights reserved.
//

import XCTest
@testable import EverydayWallpaperBar

class MiscTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDateExtensionIsToday() {
        let date:NSDate = NSDate()
        
        XCTAssert(date.isToday() , "NSDate isToday extension func fail")
    }
}
