//
//  AccountApiTests.swift
//  StegoTests
//
//  Created by George Sealy on 15/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import XCTest

class AccountApiTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVerifyCredentialsRoute() {
        
        let endPoint = Accounts.verifyCredentials
//        let emptyParams: [String: Any] = [:]
        
        XCTAssertEqual(endPoint.route.method, .get)
        XCTAssertEqual(endPoint.route.path, "accounts/verify_credentials")
        XCTAssert(endPoint.route.parameters.isEmpty)
        XCTAssert(endPoint.resultType == Account.self)

//        GET /api/v1/accounts/verify_credentials
//
//        id     The ID of the account     no
//        username     The username of the account     no
//        acct     Equals username for local users, includes @domain for remote ones     no
//        display_name     The account's display name     no
//        locked     Boolean for when the account cannot be followed without waiting for approval first     no
//        created_at     The time the account was created     no
//        followers_count     The number of followers for the account     no
//        following_count     The number of accounts the given account is following     no
//        statuses_count     The number of statuses the account has made     no
//        note     Biography of user     no
//        url     URL of the user's profile page (can be remote)     no
//        avatar     URL to the avatar image     no
//        avatar_static     URL to the avatar static image (gif)     no
//        header     URL to the header image     no
//        header_static     URL to the header static image (gif)     no
//        emojis     Array of Emoji in account username and note     no
//        moved     If the owner decided to switch accounts, new account is in this attribute     yes
//        fields     Array of profile metadata field, each element has 'name' and 'value'     yes
//        bot     Boolean to indicate that the account performs automated actions
//        Returns the authenticated user's Account with an extra attribute source which contains these keys:
//        Attribute     Description
//        privacy     Selected preference: Default privacy of new toots
//        sensitive     Selected preference: Mark media as sensitive by default?
//        note     Plain-text version of the account's note
//        fields     Array of profile metadata, each element has 'name' and 'value'
        
    }
    
}
