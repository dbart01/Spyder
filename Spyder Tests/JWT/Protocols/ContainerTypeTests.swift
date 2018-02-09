//
//  ContainerTypeTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-02-06.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class ContainerTypeTests: XCTestCase {

    // ----------------------------------
    //  MARK: - Count -
    //
    func testCount() {
        let container = TestContainer(values: ["key" : "value"])
        XCTAssertEqual(container.count, 1)
        
        container.values.removeAll()
        
        XCTAssertEqual(container.count, 0)
    }
    
    // ----------------------------------
    //  MARK: - Subscript -
    //
    func testStringSubscript() {
        var container = TestContainer()
        
        container["animal"]   = "dog"
        container["legCount"] = 4
        
        XCTAssertEqual(container.count, 2)
        XCTAssertEqual(container["animal"]   as! String, "dog")
        XCTAssertEqual(container["legCount"] as! Int,    4)
    }
    
    func testKeySubscript() {
        var container = TestContainer()
        
        container[JWT.Key.alg] = "ES256"
        
        XCTAssertEqual(container.count, 1)
        XCTAssertEqual(container[JWT.Key.alg] as! String, "ES256")
    }
}

// ----------------------------------
//  MARK: - TestContainer -
//
private class TestContainer: ContainerType {
    
    var values: [String : Any] = [:]
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(values: [String : Any] = [:]) {
        self.values = values
    }
}
