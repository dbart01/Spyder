//
//  ASCII.RenderContext.swift
//  Spyder
//
//  Copyright (c) 2016 Dima Bart
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  The views and conclusions contained in the software and documentation are those
//  of the authors and should not be interpreted as representing official policies,
//  either expressed or implied, of the FreeBSD Project.
//

import Foundation

extension ASCII {
    struct RenderContext {
        let paddingString        = " "
        let rowEdgeString        = "|"
        let cellSeparatorString  = "|"
        let separatorEdgeString  = "+"
        let separatorString      = "-"
        let lineSeparator        = "\n"
        
        var edgePadding:   Int
        var maxCellWidth:  Int
        var minRowWidth:   Int
        var fillingLength: Int
        var spaceToFill:   Int
        
        // ----------------------------------
        //  MARK: - Init -
        //
        init(edgePadding: Int = 2, maxCellWidth: Int = 80, minRowWidth: Int = 60, fillingLength: Int = 0, spaceToFill: Int = 0) {
            self.edgePadding   = edgePadding
            self.maxCellWidth  = maxCellWidth
            self.minRowWidth   = minRowWidth
            self.fillingLength = fillingLength
            self.spaceToFill   = spaceToFill
        }
        
        // ----------------------------------
        //  MARK: - Padding -
        //
        func applyPadding(to input: String) -> String {
            let padding = self.paddingString.multiply(by: self.edgePadding)
            return "\(padding)\(input)\(padding)"
        }
    }
}
