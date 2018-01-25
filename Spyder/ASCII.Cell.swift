//
//  ASCII.Cell.swift
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
    struct Cell: WrappingType, ContentType, ExpressibleByStringLiteral {
        
        let flex: Bool
        
        private(set) var content: String
        
        // ----------------------------------
        //  MARK: - Init -
        //
        init(content: String, flex: Bool = false) {
            self.content = content
            self.flex    = flex
        }
        
        init(convertible: CustomStringConvertible, flex: Bool = false) {
            self.init(content: convertible.description, flex: flex)
        }
        
        init(stringLiteral value: String) {
            self.init(content: value)
        }
        
        // ----------------------------------
        //  MARK: - WrappingType -
        //
        func wrap(in context: ASCII.RenderContext) -> [RenderType] {
            let length = self.length(in: context)
            let limit  = context.maxCellWidth - (context.edgePadding * 2)
            if length > limit {
                
                let separator = " " as Character
                let tokens    = self.content.split(separator: separator)
                if tokens.count > 0 {
                    
                    var cells: [Cell] = []
                    
                    var cell = Cell(content: "")
                    for token in tokens {
                        if cell.length(in: context) + token.count + 1 < limit { // + 1 for separator
                            if cell.content.count > 0 {
                                cell.content = "\(cell.content)\(separator)\(token)"
                            } else {
                                cell.content = "\(token)"
                            }
                        } else {
                            cells.append(cell)
                            cell = Cell(content: "\(token)")
                        }
                    }
                    
                    cells.append(cell)
                    
                    return cells
                }
            }
            return [self]
        }
        
        // ----------------------------------
        //  MARK: - RenderType -
        //
        func length(in context: ASCII.RenderContext) -> Int {
            return context.edgePadding * 2 + self.content.removedColors().count
        }
        
        func render(in context: ASCII.RenderContext) -> String {
            var result = context.applyPadding(to: self.content)
            
            if context.spaceToFill > 0 {
                result += " ".multiply(by: context.spaceToFill)
            }
            
            return result
        }
    }
}
