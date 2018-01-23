//
//  String+RenderTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-22.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class String_RenderTests: XCTestCase {
    
    func testMultiplyString() {
        let string = " "
        let result = string.multiply(by: 4)
        
        XCTAssertEqual(result, "    ")
    }
}
