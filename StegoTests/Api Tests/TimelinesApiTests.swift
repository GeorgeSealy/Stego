//
//  TimelinesApiTests.swift
//  StegoTests
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import XCTest

class TimelinesApiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVerifyCredentialsRoute() {
        
        let endPoint = Timelines.home
        
        XCTAssertEqual(endPoint.route.method, .get)
        XCTAssertEqual(endPoint.route.path, "timelines/home")
        XCTAssert(endPoint.route.parameters.isEmpty)
        XCTAssert(endPoint.resultType == [StatusModel].self)

    }
    
}
