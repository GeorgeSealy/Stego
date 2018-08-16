//
//  AccessModelTests.swift
//  StegoTests
//
//  Created by George Sealy on 14/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import XCTest

class AccessModelTests: XCTestCase {
    
    let accessToken = "eda215064987f34c6494f227cd1813b0d7d538541441e30fe22c7c33f39f1a52"
    let createdTimestamp = 1534196895
    let tokenType = AccessModel.TokenType.bearer

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func makeJsonData(accessToken: String? = nil,
                              createdTimestamp: Int? = nil,
                              tokenType: AccessModel.TokenType? = nil,
                              scope: String? = nil) -> Data {
        var jsonString = ""
        
        if let accessToken = accessToken {
            
            if !jsonString.isEmpty {
                jsonString += ","
            }
            
            jsonString += "\"access_token\": \"\(accessToken)\""
        }
        
        if let scope = scope {
            
            if !jsonString.isEmpty {
                jsonString += ","
            }
            
            jsonString += "\"scope\": \"\(scope)\""
        }
        
        if let tokenType = tokenType {
            
            if !jsonString.isEmpty {
                jsonString += ","
            }
            
            jsonString += "\"token_type\": \"\(tokenType)\""
        }
        
        if let createdTimestamp = createdTimestamp {
            
            if !jsonString.isEmpty {
                jsonString += ","
            }
            
            jsonString += "\"created_at\": \(createdTimestamp)"
        }

        jsonString = "{" + jsonString
        jsonString += "}"
        
        return jsonString.data(using: .utf8)!
    }
    
    func testEmptyModel() {
        
        let jsonData = makeJsonData(accessToken: nil)
        
        XCTAssertThrowsError(try jsonData.decoded() as AccessModel)
    }
    
    func testPartialModel() {
        
        let jsonData = makeJsonData(accessToken: accessToken)
        
        XCTAssertThrowsError(try jsonData.decoded() as AccessModel)
    }

    func testFullValidModel() {
        
        let jsonData = makeJsonData(accessToken: accessToken, createdTimestamp: createdTimestamp, tokenType: tokenType, scope: "read write follow")
        
        XCTAssertNoThrow(try jsonData.decoded() as AccessModel) { (model) in
            XCTAssertEqual(model.accessToken, accessToken)
            XCTAssertEqual(model.createdAt.timeIntervalSince1970, TimeInterval(createdTimestamp))
            XCTAssertEqual(model.tokenType, tokenType)
            XCTAssertEqual(model.scope.count, 3)
            XCTAssertNotNil(model.scope.contains(.read))
            XCTAssertNotNil(model.scope.contains(.write))
            XCTAssertNotNil(model.scope.contains(.follow))
        }
    }
    
    func testSingleScopeModel() {
        
        let jsonData = makeJsonData(accessToken: accessToken, createdTimestamp: createdTimestamp, tokenType: tokenType, scope: "write")
        
        XCTAssertNoThrow(try jsonData.decoded() as AccessModel) { (model) in
            XCTAssertEqual(model.accessToken, accessToken)
            XCTAssertEqual(model.createdAt.timeIntervalSince1970, TimeInterval(createdTimestamp))
            XCTAssertEqual(model.tokenType, tokenType)
            XCTAssertEqual(model.scope.count, 1)
            XCTAssertNotNil(model.scope.contains(.follow))
        }
        
    }
}
