//
//  ASCII.SeparatorTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-22.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class ASCIISeparatorTests: XCTestCase {
    
    // ----------------------------------
    //  MARK: - Length -
    //
    func testLength() {
        let context = ASCII.RenderContext(
            edgePadding:   2,
            maxCellWidth:  0,
            fillingLength: 100
        )
        
        let separator = ASCII.Separator()
        let length    = separator.length(in: context)
        
        XCTAssertEqual(length, 100)
    }
    
    // ----------------------------------
    //  MARK: - Rendering -
    //
    func testRender() {
        let context = ASCII.RenderContext(
            edgePadding:   1,
            maxCellWidth:  0,
            fillingLength: 10
        )
        
        let separator = ASCII.Separator()
        let result    = separator.render(in: context)
        
        XCTAssertEqual(result, "+--------+")
    }
}
