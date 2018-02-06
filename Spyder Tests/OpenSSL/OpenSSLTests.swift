//
//  OpenSSLTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-02-06.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class OpenSSLTests: XCTestCase {

    static let message       = "This is a test message"
    static let messageData   = OpenSSLTests.message.data(using: .utf8)!
    static let privateKeyURL = Bundle(for: OpenSSLTests.self).url(forResource: "private-test-key", withExtension: "p8")!
    
    // ----------------------------------
    //  MARK: - Sign -
    //
    func testSignString() {
        let signature = OpenSSL.sign(using: OpenSSLTests.privateKeyURL, message: OpenSSLTests.message)
        XCTAssertNotNil(signature)
        XCTAssertTrue(signature!.count > 0)
    }
    
    func testSignData() {
        let signature = OpenSSL.sign(using: OpenSSLTests.privateKeyURL, message: OpenSSLTests.messageData)
        XCTAssertNotNil(signature)
        XCTAssertTrue(signature!.count > 0)
    }
}
