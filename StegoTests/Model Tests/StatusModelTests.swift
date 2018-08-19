//
//  StatusModelTests.swift
//  StegoTests
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import XCTest

class StatusModelTests: XCTestCase {
    
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
        jsonString += "\"content\": \"html\","
//        jsonString += "\"acct\": \"B\","
//        jsonString += "\"display_name\": \"C\""
        
        
        jsonString = "{" + jsonString
        jsonString += "}"
        
        return jsonString.data(using: .utf8)!
    }

//    id     The ID of the status     no
//    uri     A Fediverse-unique resource ID     no
//    url     URL to the status page (can be remote)     yes
//    account     The Account which posted the status     no
//    in_reply_to_id     null or the ID of the status it replies to     yes
//    in_reply_to_account_id     null or the ID of the account it replies to     yes
//    reblog     null or the reblogged Status     yes
//    content     Body of the status; this will contain HTML (remote HTML already sanitized)     no
//    created_at     The time the status was created     no
//    emojis     An array of Emoji     no
//    reblogs_count     The number of reblogs for the status     no
//    favourites_count     The number of favourites for the status     no
//    reblogged     Whether the authenticated user has reblogged the status     yes
//    favourited     Whether the authenticated user has favourited the status     yes
//    muted     Whether the authenticated user has muted the conversation this status from     yes
//    sensitive     Whether media attachments should be hidden by default     no
//    spoiler_text     If not empty, warning text that should be displayed before the actual content     no
//    visibility     One of: public, unlisted, private, direct     no
//    media_attachments     An array of Attachments     no
//    mentions     An array of Mentions     no
//    tags     An array of Tags     no
//    application     Application from which the status was posted     yes
//    language     The detected language for the status, if detected     yes
//    pinned     Whether this is the pinned status for the account that posted it     yes
    
    func testStatusModel() {
        
        let jsonData = makeJsonData()
        
        XCTAssertNoThrow(try jsonData.decoded()) { (model: Status) in
            XCTAssertEqual(model.id, "123")
            XCTAssertEqual(model.content, "html")
//            XCTAssertEqual(model.acct, "B")
//            XCTAssertEqual(model.displayName, "C")
        }
    }
    
}
