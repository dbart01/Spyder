//
//  ASCII.RendererTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-22.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class ASCIIRendererTests: XCTestCase {
    
    // ----------------------------------
    //  MARK: - Init -
    //
    func testInit() {
        // TODO: Implement
    }
    
    // ----------------------------------
    //  MARK: - Rendering -
    //
    func testRender() {
        var renderer               = ASCII.Renderer()
        renderer.edgePadding       = 1
        renderer.charactersPerLine = 80
        
        renderer += ASCII.Row(
            ASCII.Cell(content: "")
        )
        renderer += ASCII.Separator()
        renderer += ASCII.Row([
            ASCII.Cell(content: "✓"),
            ASCII.Cell(content: "Test iOS", flex: true),
            ASCII.Cell(content: "69 sec"),
        ])
        renderer += ASCII.Separator()
        renderer += ASCII.Row(
            ASCII.Cell(content: "Update available: 1.1.4 -> 1.1.5")
        )
        renderer += ASCII.Separator()
        
        let result = renderer.render()
        let expectation = """
        |                                  |
        +----------------------------------+
        | ✓ | Test iOS            | 69 sec |
        +----------------------------------+
        | Update available: 1.1.4 -> 1.1.5 |
        +----------------------------------+
        """
        XCTAssertEqual(result, expectation)
    }
}
