//
//  String+ColorsTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-25.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class String_ColorsTests: XCTestCase {
    
    func testRemoveColors() {
        let string = "\u{001B}1;32m✓ Success\u{001B}0m"
        let result = string.removedColors()
        
        XCTAssertEqual(result, "✓ Success")
    }
}
