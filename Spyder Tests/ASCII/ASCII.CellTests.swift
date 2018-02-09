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
    func testInitLiteral() {
        let cell: ASCII.Cell = "Something"
        XCTAssertEqual(cell.content, "Something")
    }
    
    func testInitConvertible() {
        let cell = ASCII.Cell(convertible: Convertible("cool"))
        XCTAssertEqual(cell.content, "##cool##")
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
        
        let cell   = ASCII.Cell(content: "Something")
        let length = cell.length(in: context)
        
        XCTAssertEqual(length, 9 + 2 + 2)
    }
    
    // ----------------------------------
    //  MARK: - Wrapping -
    //
    func testWrapMultiLine() {
        let context = ASCII.RenderContext(
            edgePadding:   1,
            maxCellWidth:  32,
            fillingLength: 0
        )
        
        let cell    = ASCII.Cell(content: "Lorem ipsum dolor sit amet, consecteturadipiscing elit, sed do eiusmod tempor incididunt labore et dolore magna aliqua.")
        let cells   = cell.wrap(in: context)
        let results = cells.map {
            $0.render(in: context)
        }
        
        XCTAssertEqual(results, [
            " Lorem ipsum dolor sit amet, ",
            " consecteturadipiscing elit, ",
            " sed do eiusmod tempor ",
            " incididunt labore et dolore ",
            " magna aliqua. ",
        ])
    }
    
    func testWrapSingleLine() {
        let context = ASCII.RenderContext(
            edgePadding:   1,
            maxCellWidth:  30,
            fillingLength: 0
        )
        
        let cell    = ASCII.Cell(content: "Lorem ipsum dolor")
        let cells   = cell.wrap(in: context)
        let results = cells.map {
            $0.render(in: context)
        }
        
        XCTAssertEqual(results, [
            " Lorem ipsum dolor ",
        ])
    }
    
    // ----------------------------------
    //  MARK: - Rendering -
    //
    func testRender() {
        let context = ASCII.RenderContext(
            edgePadding:   1,
            maxCellWidth:  0,
            fillingLength: 0
        )
        
        let cell   = "Success" as ASCII.Cell
        let result = cell.render(in: context)
        
        XCTAssertEqual(result, " Success ")
    }
    
    func testRenderWithSpaceFilling() {
        let context = ASCII.RenderContext(
            edgePadding:   1,
            maxCellWidth:  0,
            spaceToFill:  10
        )
        
        let cell   = "Success" as ASCII.Cell
        let result = cell.render(in: context)
        
        XCTAssertEqual(result, " Success           ")
    }
}

// ----------------------------------
//  MARK: - Convertible -
//
private class Convertible: CustomStringConvertible {
    
    let content: String
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(_ content: String) {
        self.content = content
    }
    
    var description: String {
        return "##\(self.content)##"
    }
}
