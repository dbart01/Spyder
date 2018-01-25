//
//  ASCII.Renderer.swift
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
    class Renderer {
        
        var edgePadding:  Int = 2
        var maxCellWidth: Int = 80
        var minRowWidth:  Int = 0
        
        private(set) var renderables: [RenderType] = []
        
        // ----------------------------------
        //  MARK: - Init -
        //
        convenience init() {
            self.init([])
        }
        
        init(_ renderables: [RenderType]) {
            self.renderables = renderables
        }
        
        // ----------------------------------
        //  MARK: - Wrapping -
        //
        func wrap(in context: ASCII.RenderContext) -> [RenderType] {
            var renderables: [RenderType] = []
            
            for renderable in self.renderables {
                if let wrappable = renderable as? WrappingType {
                    renderables.append(contentsOf: wrappable.wrap(in: context))
                } else {
                    renderables.append(renderable)
                }
            }
            
            return renderables
        }
        
        // ----------------------------------
        //  MARK: - Render -
        //
        func render() -> String {
            var context = ASCII.RenderContext(
                edgePadding:   self.edgePadding,
                maxCellWidth:  self.maxCellWidth,
                minRowWidth:   self.minRowWidth,
                fillingLength: 0,
                spaceToFill:   0
            )
            
            let wrappedRenderables = self.wrap(in: context)
            let largestLength      = self.longest(of: wrappedRenderables, in: context)
            
            context.fillingLength = max(largestLength, minRowWidth)
            
            return wrappedRenderables.map {
                $0.render(in: context)
            }.joined(separator: context.lineSeparator)
        }
        
        func longest(of renderables: [RenderType], in context: ASCII.RenderContext) -> Int {
            var largestLength = 0
            renderables.forEach {
                let length = $0.length(in: context)
                if length > largestLength {
                    largestLength = length
                }
            }
            return largestLength
        }
    }
}

extension ASCII.Renderer {
    static func +=(lhs: inout ASCII.Renderer, rhs: RenderType) {
        lhs.renderables.append(rhs)
    }
}
