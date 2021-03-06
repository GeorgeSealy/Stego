//
//  OauthApiTests.swift
//  StegoTests
//
//  Created by George Sealy on 14/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import XCTest

class OauthApiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReturnTypes() {
        XCTAssert(Oauth.accessToken(clientId: "A", clientSecret: "B", code: "C", redirectUri: "D").resultType == AccessModel.self)
    }
    
}
