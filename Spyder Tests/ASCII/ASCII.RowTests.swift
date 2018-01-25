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
    //  MARK: - Wrapping -
    //
    func testWrap() {
        let context = ASCII.RenderContext(
            edgePadding:   1,
            maxCellWidth:  20,
            fillingLength: 0
        )
        
        let cell1: ASCII.Cell = "OK"
        let cell2: ASCII.Cell = "Description: An async operation to compile source files."
        let cell3: ASCII.Cell = "3.4 sec"
        
        let row  = ASCII.Row([cell1, cell2 , cell3])
        let rows = row.wrap(in: context) as! [ASCII.Row]
        
        XCTAssertEqual(rows[0].cells[0].content, "OK")
        XCTAssertEqual(rows[0].cells[1].content, "Description: An")
        XCTAssertEqual(rows[0].cells[2].content, "3.4 sec")
        
        XCTAssertEqual(rows[1].cells[0].content, "  ")
        XCTAssertEqual(rows[1].cells[1].content, "async operation")
        XCTAssertEqual(rows[1].cells[2].content, "       ")
        
        XCTAssertEqual(rows[2].cells[0].content, "  ")
        XCTAssertEqual(rows[2].cells[1].content, "to compile")
        XCTAssertEqual(rows[2].cells[2].content, "       ")
        
        XCTAssertEqual(rows[3].cells[0].content, "  ")
        XCTAssertEqual(rows[3].cells[1].content, "source files.")
        XCTAssertEqual(rows[3].cells[2].content, "       ")
    }
    
    // ----------------------------------
    //  MARK: - Length -
    //
    func testLength() {
        let context = ASCII.RenderContext(
            edgePadding:   2,
            maxCellWidth:  0,
            fillingLength: 0
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
            edgePadding:   2,
            maxCellWidth:  0,
            fillingLength: 0
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
            edgePadding:   2,
            maxCellWidth:  0,
            fillingLength: 40,
            spaceToFill:   0
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
            edgePadding:   1,
            maxCellWidth:  0,
            fillingLength: 34,
            spaceToFill:   0
        )
        
        let cell1 = ASCII.Cell(content: "OK")
        let cell2 = ASCII.Cell(content: "Success", flex: true)
        let cell3 = ASCII.Cell(content: "3.4 sec")
        
        let row    = ASCII.Row([cell1, cell2 , cell3])
        let result = row.render(in: context)
        
        XCTAssertEqual(result, "| OK | Success         | 3.4 sec |")
    }
}
