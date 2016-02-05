//
//  NewtorkStatusTests.swift
//  EverydayWallpaperUtils
//
//  Created by Hugo PEREIRA on 05.02.16.
//  Copyright © 2016 Hugo PEREIRA. All rights reserved.
//

import XCTest

@testable import EverydayWallpaperUtils

class NetworkStatusTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConnectivity() {
        XCTAssert(NetworkStatus.isConnectedToNetwork() == true, "Error if you are connected to network")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
