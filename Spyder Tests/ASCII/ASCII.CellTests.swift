//
//  ASCII.CellTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-22.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class ASCIICellTests: XCTestCase {
    
    // ----------------------------------
    //  MARK: - String Literal -
    //
    func testStringLiteral() {
        let cell: ASCII.Cell = "Something"
        XCTAssertEqual(cell.content, "Something")
    }
    
    // ----------------------------------
    //  MARK: - Length -
    //
    func testLength() {
        let context = ASCII.RenderContext(
            edgePadding:       2,
            charactersPerLine: 0,
            fillingLength:     0
        )
        
        let cell   = ASCII.Cell(content: "Something")
        let length = cell.length(in: context)
        
        XCTAssertEqual(length, 9 + 2 + 2)
    }
    
    // ----------------------------------
    //  MARK: - Rendering -
    //
    func testRender() {
        let context = ASCII.RenderContext(
            edgePadding:       1,
            charactersPerLine: 0,
            fillingLength:     0
        )
        
        let cell   = "Success" as ASCII.Cell
        let result = cell.render(in: context)
        
        XCTAssertEqual(result, " Success ")
    }
}
