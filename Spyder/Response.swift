//
//  Response.swift
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

struct Response: CustomDebugStringConvertible {
    
    typealias DataType = [String : AnyObject]
    
    let code:     String
    let status:   String
    let response: HTTPURLResponse?
    let failure:  Failure?
    let error:    Error?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init?(response: HTTPURLResponse?, data: Data?, error: Error?) {
        if response == nil && data == nil && error == nil {
            return nil
        }
        
        self.code     = "\(response?.statusCode ?? -1)"
        self.status   = Response.status(for: response?.statusCode)
        self.response = response
        self.error    = error
        
        if let data = data {
            do {
                self.failure = try JSONDecoder().decode(Failure.self, from: data)
            } catch {
                self.failure = nil
            }
        } else {
            self.failure = nil
        }
    }
    
    // ----------------------------------
    //  MARK: - Conveniences -
    //
    private var successful: Bool {
        if let response = self.response {
            return response.statusCode == 200
        }
        return false
    }
    
    private func value(forHeader key: String) -> String? {
        if let response = self.response,
            let value = response.allHeaderFields[key] as? String {
            return value
        }
        return nil
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
            
            if let notificationID = self.value(forHeader: Headers.Key.id) {
                renderer += ASCII.Row(ASCII.Cell(convertible: "Notification Identifier".yellowText))
                renderer += ASCII.Row(ASCII.Cell(convertible: notificationID))
                renderer += ASCII.Separator()
            }
            
        } else {
            
            renderer += ASCII.Separator()
            renderer += ASCII.Row([
                ASCII.Cell(convertible: "✗".redText.bold),
                ASCII.Cell(convertible: self.status.redText.bold, flex: true),
                ASCII.Cell(convertible: self.code.redText.bold),
            ])
            renderer += ASCII.Separator()

            if let failure = self.failure {
                let unknowDescription = "Unknow error. This might be a new type of error. We couldn't find a description for it."
                
                renderer += ASCII.Row(ASCII.Cell(convertible: failure.reason.error.yellowText))
                renderer += ASCII.Row(ASCII.Cell(convertible: failure.reason.description ?? unknowDescription))
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

// ----------------------------------
//  MARK: - Response Codes -
//
extension Response {
    
    private static func status(for code: Int?) -> String {
        if let code = code,
            let status = self.statusCodes[code] {
            return status
        }
        return "Unknown Error"
    }
    
    private static let statusCodes: [Int : String] = [
        200 : "Success",
        400 : "Bad request",
        403 : "There was an error with the certificate.",
        405 : "The request used a bad :method value. Only POST requests are supported.",
        410 : "The device token is no longer active for the topic.",
        413 : "The notification payload was too large.",
        429 : "The server received too many requests for the same device token.",
        500 : "Internal server error",
        503 : "The server is shutting down and unavailable.",
    ]
}
