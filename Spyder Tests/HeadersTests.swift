//
//  HeadersTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-21.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class HeadersTests: XCTestCase {
    
    func testEncodableFull() {
        let headers = Headers(
            id:       "abc123",
            topic:    "test-notification",
            priority: 5,
            expiry:   100
        )
        
        let dictionary = headers.dictionary
        
        XCTAssertEqual(dictionary.count, 4)
        XCTAssertEqual(dictionary["apns-id"],       "abc123")
        XCTAssertEqual(dictionary["apns-topic"],    "test-notification")
        XCTAssertEqual(dictionary["apns-priority"], "5")
        XCTAssertEqual(dictionary["apns-expiry"],   "100")
    }
    
    func testEncodableEmpty() {
        let headers = Headers()
        
        let dictionary = headers.dictionary
        
        XCTAssertEqual(dictionary.count, 0)
    }
}
