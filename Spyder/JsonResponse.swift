//
//  JsonResponse.swift
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
import Bloom

struct JsonResponse: ResponseType, CustomDebugStringConvertible {
    
    typealias DataType = [String : AnyObject]
    
    let response: HTTPURLResponse?
    let data:     DataType?
    let error:    Error?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init?(response: HTTPURLResponse?, data: Data?, error: Error?) {
        if response == nil && data == nil && error == nil {
            return nil
        }
        
        self.response = response
        self.error    = error
        
        if let data = data {
            self.data = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
        } else {
            self.data = nil
        }
    }
    
    // ----------------------------------------
    //  MARK: - CustomDebugStringConvertible -
    //
    var debugDescription: String {
        var renderer          = ASCII.Renderer()
        renderer.edgePadding  = 1
        renderer.minRowWidth  = 50
        renderer.maxCellWidth = 50
        
        if self.successful {
            renderer += ASCII.Separator()
            renderer += ASCII.Row([
                ASCII.Cell(convertible: "✓".greenText.bold),
                ASCII.Cell(convertible: "Success".greenText.bold, flex: true),
            ])
            renderer += ASCII.Separator()
            
            if let notificationID = self.stringForHeader("apns-id") {
                renderer += ASCII.Row(ASCII.Cell(convertible: "Notification Identifier".yellowText))
                renderer += ASCII.Row(ASCII.Cell(convertible: notificationID))
                renderer += ASCII.Separator()
            }
            
        } else {
            
            let code:   String
            let status: String
            
            if let response = self.response, let message = StatusDescriptions[response.statusCode] {
                code   = "\(response.statusCode)"
                status = message
            } else {
                code   = "-1"
                status = "Error"
            }
            
            renderer += ASCII.Separator()
            renderer += ASCII.Row([
                ASCII.Cell(convertible: "✗".redText.bold),
                ASCII.Cell(convertible: status.redText.bold, flex: true),
                ASCII.Cell(convertible: code.redText.bold),
            ])
            renderer += ASCII.Separator()

            if let data = self.data, data.count > 0 {
                
                if let reason = data["reason"] as? String,
                    let summary = ReasonDescriptions[reason] {
                
                    renderer += ASCII.Row(ASCII.Cell(convertible: reason.yellowText))
                    renderer += ASCII.Row(ASCII.Cell(convertible: summary))
                    
                } else {
                    renderer += ASCII.Row(ASCII.Cell(convertible: data))
                }
                renderer += ASCII.Separator()
            }

            if let error = self.error {
                renderer += ASCII.Row(ASCII.Cell(convertible: error.localizedDescription))
                renderer += ASCII.Separator()
            }
        }
        
        return "\n" + renderer.render() + "\n"
    }
}
