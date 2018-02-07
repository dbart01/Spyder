//
//  Data+Base64Tests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-02-06.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class Data_Base64Tests: XCTestCase {

    // ----------------------------------
    //  MARK: - Base64 -
    //
    func testStandardBenchmark() {
        let content = "j_}u~?M~|\\/.><~9"
        let encoded = content.data(using: .utf8)?.base64EncodedString()
        XCTAssertEqual(encoded, "al99dX4/TX58XC8uPjx+OQ==")
    }
    
    func testURLEncoding() {
        let content = "j_}u~?M~|\\/.><~9"
        let encoded = content.data(using: .utf8)?.base64URL
        XCTAssertEqual(encoded, "al99dX4_TX58XC8uPjx-OQ")
    }
}
