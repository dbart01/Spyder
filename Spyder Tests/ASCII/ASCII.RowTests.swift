//
//  ASCII.RowTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-22.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class ASCIIRowTests: XCTestCase {
    
    // ----------------------------------
    //  MARK: - Init -
    //
    func testInitSingle() {
        let cell: ASCII.Cell = "Stuff"
        let row = ASCII.Row(cell)
        
        XCTAssertEqual(row.cells.count, 1)
        XCTAssertEqual(row.cells[0].content, "Stuff")
    }
    
    func testInitMulti() {
        let cell1: ASCII.Cell = "Stuff"
        let cell2: ASCII.Cell = "Things"
        let row = ASCII.Row([cell1, cell2])
        
        XCTAssertEqual(row.cells.count, 2)
        XCTAssertEqual(row.cells[0].content, "Stuff")
        XCTAssertEqual(row.cells[1].content, "Things")
    }
    
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
        
        let cell1: ASCII.Cell = "OK"
        let cell2: ASCII.Cell = "Success"
        let cell3: ASCII.Cell = "3.4 sec"
        
        let row    = ASCII.Row([cell1, cell2 , cell3])
        let length = row.length(in: context)
        
        // "|  OK  |  Success  |  3.4 sec  |"
        
        XCTAssertEqual(length, 32)
    }
    
    // ----------------------------------
    //  MARK: - Rendering -
    //
    func testRenderWithoutFilling() {
        let context = ASCII.RenderContext(
            edgePadding:       2,
            charactersPerLine: 0,
            fillingLength:     0
        )
        
        let cell1: ASCII.Cell = "OK"
        let cell2: ASCII.Cell = "Success"
        let cell3: ASCII.Cell = "3.4 sec"
        
        let row    = ASCII.Row([cell1, cell2 , cell3])
        let result = row.render(in: context)
        
        XCTAssertEqual(result, "|  OK  |  Success  |  3.4 sec  |")
    }
    
    func testRenderByFillingDefault() {
        let context = ASCII.RenderContext(
            edgePadding:       2,
            charactersPerLine: 0,
            fillingLength:     40,
            spaceToFill:       0
        )
        
        let cell1: ASCII.Cell = "OK"
        let cell2: ASCII.Cell = "Success"
        let cell3: ASCII.Cell = "3.4 sec"
        
        let row    = ASCII.Row([cell1, cell2 , cell3])
        let result = row.render(in: context)
        
        XCTAssertEqual(result, "|  OK  |  Success  |  3.4 sec          |")
    }
    
    func testRenderByFillingSpecific() {
        let context = ASCII.RenderContext(
            edgePadding:       1,
            charactersPerLine: 0,
            fillingLength:     34,
            spaceToFill:       0
        )
        
        let cell1 = ASCII.Cell(content: "OK")
        let cell2 = ASCII.Cell(content: "Success", flex: true)
        let cell3 = ASCII.Cell(content: "3.4 sec")
        
        let row    = ASCII.Row([cell1, cell2 , cell3])
        let result = row.render(in: context)
        
        XCTAssertEqual(result, "| OK | Success         | 3.4 sec |")
    }
}
