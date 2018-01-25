//
//  Int+ClampTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-23.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class Int_ClampTests: XCTestCase {
    
    func testClampOutsideUpperBound() {
        let result = 250.clamp(min: 50, max: 100)
        XCTAssertEqual(result, 100)
    }
    
    func testClampOutsideLowerBound() {
        let result = 25.clamp(min: 50, max: 100)
        XCTAssertEqual(result, 50)
    }
    
    func testClampWithinRange() {
        let result = 75.clamp(min: 50, max: 100)
        XCTAssertEqual(result, 75)
    }
}
