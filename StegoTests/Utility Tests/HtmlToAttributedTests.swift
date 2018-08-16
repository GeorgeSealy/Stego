//
//  HtmlToAttributedTests.swift
//  StegoTests
//
//  Created by George Sealy on 16/08/18.
//  Copyright © 2018 George Sealy. All rights reserved.
//

import XCTest

class HtmlToAttributedTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyString() {
        let html = ""
        
        let attributed = html.parseMastodonHtml()
        
        XCTAssertEqual(attributed.length, 0)
    }
    
    func testStripParagraphs() {
        let html = "<p>photches (phone notches)</p>"
        
        let attributed = html.parseMastodonHtml()
        
        XCTAssertEqual(attributed, NSAttributedString(string: "photches (phone notches)"))
    }
    
    func testConvertHtmlApostrophesEtc() {
        let html = "<p>Don&apos;t mind me, _just_ *testing*.</p>"
        
        let attributed = html.parseMastodonHtml()
        
        XCTAssertEqual(attributed, NSAttributedString(string: "Don't mind me, _just_ *testing*."))
    }
    
    func testSimpleEmoji() {
        let html = "<p>Hello fellow frustrated Twitter users! Good to be here 🙂</p>"
        
        let attributed = html.parseMastodonHtml()
        
        XCTAssertEqual(attributed, NSAttributedString(string: "Hello fellow frustrated Twitter users! Good to be here 🙂"))
    }
    
    func testBreaks() {
        let html = "<p>Okay folks, mystery solved.<br>Okay folks, mystery solved.</p>"
        
        let attributed = html.parseMastodonHtml()
        
        XCTAssertEqual(attributed, NSAttributedString(string: "Okay folks, mystery solved.\nOkay folks, mystery solved."))
    }

}
