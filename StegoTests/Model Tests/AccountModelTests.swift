//
//  AccountModelTests.swift
//  StegoTests
//
//  Created by George Sealy on 15/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import XCTest

class AccountModelTests: XCTestCase {
 
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    private func makeJsonData() -> Data {
        var jsonString = ""
        
        jsonString += "\"id\": \"123\","
        jsonString += "\"username\": \"A\","
        jsonString += "\"acct\": \"B\","
        jsonString += "\"display_name\": \"C\""

        
        jsonString = "{" + jsonString
        jsonString += "}"
        
        return jsonString.data(using: .utf8)!
    }
    
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

    func testAccountModel() {
        
        let jsonData = makeJsonData()
        
        XCTAssertNoThrow(try jsonData.decoded()) { (model: AccountModel) in
            XCTAssertEqual(model.id, "123")
            XCTAssertEqual(model.username, "A")
            XCTAssertEqual(model.acct, "B")
            XCTAssertEqual(model.displayName, "C")
        }
        
    }
    
}
