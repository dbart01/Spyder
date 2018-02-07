//
//  ContentTypeTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-02-07.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class ContentTypeTests: XCTestCase {

    // ----------------------------------
    //  MARK: - Copy -
    //
    func testCopy() {
        let content1 = Content(content: "cool", flex: false)
        let content2 = content1.copy()
        
        XCTAssertFalse(content1 === content2)
        
        XCTAssertEqual(content1.content, content2.content)
        XCTAssertEqual(content1.flex,    content2.flex)
    }
    
    func testBlankCopy() {
        let content1 = Content(content: "cool", flex: false)
        let content2 = content1.blankCopy()
        
        XCTAssertEqual(content2.content, "    ")
        XCTAssertEqual(content1.content.count, content2.content.count)
    }
}

// ----------------------------------
//  MARK: - Content -
//
private class Content: ContentType {
    
    var flex: Bool
    var content: String
    
    // ----------------------------------
    //  MARK: - Init -
    //
    required init(content: String, flex: Bool) {
        self.content = content
        self.flex    = flex
    }
    
    // ----------------------------------
    //  MARK: - RenderType -
    //
    func length(in context: ASCII.RenderContext) -> Int {
        return self.content.count
    }
    
    func render(in context: ASCII.RenderContext) -> String {
        return self.content
    }
}
