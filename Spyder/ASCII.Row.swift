//
//  ASCII.Row.swift
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
    struct Row: WrappingType {
        
        var cells: [Cell]
        
        // ----------------------------------
        //  MARK: - Init -
        //
        init(_ cell: Cell) {
            self.init([cell])
        }
        
        init(_ cells: [Cell]) {
            self.cells = cells
        }
        
        // ----------------------------------
        //  MARK: - WrappingType -
        //
        func wrap(in context: ASCII.RenderContext) -> [RenderType] {
            var columns = self.cells.map {
                $0.wrap(in: context) as! [Cell]
            }
            
            /* ----------------------------------
             ** Fill non-wrapped cells with empty
             ** content so that number of cells
             ** in each column is the same.
             */
            let maxRows = columns.sorted { $0.count > $1.count }.first!.count
            for i in 0..<columns.count {
                while columns[i].count < maxRows {
                    columns[i].append(columns[i].last!.blankCopy())
                }
            }

            /* -----------------------------------
             ** Create a row with a cell from each
             ** column.
             */
            var rows: [Row] = []
            
            for i in 0..<maxRows {
                let cells = columns.flatMap { $0[i] }
                rows.append(Row(cells))
            }
            
            return rows
        }
        
        // ----------------------------------
        //  MARK: - RenderType -
        //
        func length(in context: ASCII.RenderContext) -> Int {
            var length = self.cellLengths(in: context).reduce(into: 0) { result, length in
                result += length
            }
            
            length += (self.cells.count - 1) * context.cellSeparatorString.count
            length += 2 * context.rowEdgeString.count
            
            return length
        }
        
        private func cellLengths(in context: ASCII.RenderContext) -> [Int] {
            return self.cells.map {
                $0.length(in: context)
            }
        }
        
        func render(in context: ASCII.RenderContext) -> String {
            let length      = self.length(in: context)
            let spaceToFill = max(context.fillingLength - length, 0)
            
            var index: Int?
            if spaceToFill > 0 {
                
                /* ----------------------------------
                 ** Find a cell that has `isFlexible`
                 ** set to `true`. Otherwise, default
                 ** to using the last cell.
                 */
                index = self.cells.index { $0.flex }
                if index == nil {
                    index = self.cells.count - 1
                }
            }
            
            let renderedCells = self.cells.enumerated().map { arg -> String in
                let (offset, cell) = arg
                
                /* -------------------------------
                 ** Modify the context of the cell
                 ** that matches the index determined
                 ** above.
                 */
                var cellContext = context
                if let index = index, offset == index {
                    cellContext.spaceToFill = spaceToFill
                }
                
                return cell.render(in: cellContext)
            }
            
            let joinedCells = renderedCells.joined(separator: context.cellSeparatorString)
            
            return "\(context.rowEdgeString)\(joinedCells)\(context.rowEdgeString)"
        }
    }
}
