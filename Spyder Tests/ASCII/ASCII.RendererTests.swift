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
    func testInitEmpty() {
        let renderer = ASCII.Renderer()
        
        XCTAssertNotNil(renderer)
        XCTAssertTrue(renderer.renderables.isEmpty)
    }
    
    func testInitWithRenderables() {
        let renderer = ASCII.Renderer([
            ASCII.Separator(),
            ASCII.Separator(),
        ])
        
        XCTAssertNotNil(renderer)
        XCTAssertEqual(renderer.renderables.count, 2)
    }
    
    // ----------------------------------
    //  MARK: - Rendering -
    //
    func testRender() {
        let renderer          = self.renderer()
        renderer.edgePadding  = 1
        renderer.maxCellWidth = 80
        renderer.minRowWidth  = 0
        
        let result = renderer.render()
        let expectation = """
        |                                  |
        +----------------------------------+
        | ✓ | Test iOS            | 69 sec |
        +----------------------------------+
        | Update available: 1.1.4 -> 1.1.5 |
        +----------------------------------+
        |                                  |
        """
        XCTAssertEqual(result, expectation)
    }
    
    func testRenderMinimumLength() {
        let renderer          = self.renderer()
        renderer.edgePadding  = 1
        renderer.maxCellWidth = 80
        renderer.minRowWidth  = 60
        
        let result = renderer.render()
        let expectation = """
        |                                                          |
        +----------------------------------------------------------+
        | ✓ | Test iOS                                    | 69 sec |
        +----------------------------------------------------------+
        | Update available: 1.1.4 -> 1.1.5                         |
        +----------------------------------------------------------+
        |                                                          |
        """
        XCTAssertEqual(result, expectation)
    }
    
    func testRenderWrapping() {
        let renderer          = self.renderer(includeDescription: true)
        renderer.edgePadding  = 1
        renderer.maxCellWidth = 46
        renderer.minRowWidth  = 0

        let result = renderer.render()
        let expectation = """
        |                                          |
        +------------------------------------------+
        | ✓ | Test iOS                    | 69 sec |
        +------------------------------------------+
        | Update available: 1.1.4 -> 1.1.5         |
        | Description: Lorem ipsum dolor sit amet, |
        | consectetur adipiscing elit, sed do      |
        | eiusmod tempor incididunt ut labore et   |
        | dolore magna aliqua.                     |
        +------------------------------------------+
        |                                          |
        """
        XCTAssertEqual(result, expectation)
    }
    
    func testRenderWrappingWithSpacers() {
        let renderer          = self.renderer(includeDescription: true, includeSpacers: true)
        renderer.edgePadding  = 1
        renderer.maxCellWidth = 46
        renderer.minRowWidth  = 0
        
        let result = renderer.render()
        let expectation = """
        |                                              |
        +----------------------------------------------+
        | ✓ | Test iOS                        | 69 sec |
        +----------------------------------------------+
        | - | Update available: 1.1.4 -> 1.1.5         |
        | - | Description: Lorem ipsum dolor sit amet, |
        |   | consectetur adipiscing elit, sed do      |
        |   | eiusmod tempor incididunt ut labore et   |
        |   | dolore magna aliqua.                     |
        +----------------------------------------------+
        |                                              |
        """
        XCTAssertEqual(result, expectation)
    }
    
    // ----------------------------------
    //  MARK: - Appending -
    //
    func testAppendSingle() {
        var renderer = ASCII.Renderer()
        renderer    += ASCII.Row(ASCII.Cell(content: "cell"))
        
        XCTAssertEqual(renderer.renderables.count, 1)
    }
    
    func testAppendMultiple() {
        var renderer = ASCII.Renderer()
        renderer    += [
            ASCII.Row(ASCII.Cell(content: "cell1")),
            ASCII.Row(ASCII.Cell(content: "cell2")),
            ASCII.Row(ASCII.Cell(content: "cell3")),
        ]
        
        XCTAssertEqual(renderer.renderables.count, 3)
    }
    
    // ----------------------------------
    //  MARK: - Build -
    //
    func renderer(includeDescription: Bool = false, includeSpacers: Bool = false) -> ASCII.Renderer {
        var renderer = ASCII.Renderer()
        
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
        
        let updateCell = ASCII.Cell(content: "Update available: 1.1.4 -> 1.1.5")
        if includeSpacers {
            renderer += ASCII.Row([
                ASCII.Cell(content: "-"),
                updateCell,
            ])
        } else {
            renderer += ASCII.Row(updateCell)
        }
        
        if includeDescription {
            
            let descriptionCell = ASCII.Cell(content: "Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            if includeSpacers {
                renderer += ASCII.Row([
                    ASCII.Cell(content: "-"),
                    descriptionCell,
                ])
            } else {
                renderer += ASCII.Row(descriptionCell)
            }
        }
        
        renderer += ASCII.Separator()
        renderer += ASCII.Row(
            ASCII.Cell(content: "")
        )
        
        return renderer
    }
}
