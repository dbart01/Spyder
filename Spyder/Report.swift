//
//  Report.swift
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

class Report {
    
    let request:     Request
    let response:    Response
    let credentials: Session.Credentials
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(request: Request, response: Response, credentials: Session.Credentials) {
        self.request     = request
        self.response    = response
        self.credentials = credentials
    }
    
    // ----------------------------------
    //  MARK: - Generation -
    //
    func generate() -> String {
        var renderer          = ASCII.Renderer()
        renderer.edgePadding  = 1
        renderer.minRowWidth  = 50
        renderer.maxCellWidth = 50
        
        if self.response.isSuccessful {
            renderer += ASCII.Separator()
            renderer += ASCII.Row([
                ASCII.Cell(convertible: "✓".greenText.bold),
                ASCII.Cell(convertible: "Success".greenText.bold, flex: true),
                ASCII.Cell(convertible: self.response.code.greenText.bold),
            ])
            renderer += ASCII.Separator()
            
            /* ----------------------------------------
             ** Attach the notification identifier of
             ** the delivered push.
             */
            if let notificationID = self.response.value(forHeader: Headers.Key.id) {
                renderer += ASCII.Row(ASCII.Cell(convertible: "Notification Identifier".yellowText))
                renderer += ASCII.Row(ASCII.Cell(convertible: notificationID))
                renderer += ASCII.Separator()
            }
            
        } else {
            
            renderer += ASCII.Separator()
            renderer += ASCII.Row([
                ASCII.Cell(convertible: "✗".redText.bold),
                ASCII.Cell(convertible: self.response.status.redText.bold, flex: true),
                ASCII.Cell(convertible: self.response.code.redText.bold),
            ])
            renderer += ASCII.Separator()
            
            if let failure = self.response.failure {
                let unknowDescription = "Unknow error. This might be a new type of error. We couldn't find a description for it."
                
                renderer += ASCII.Row(ASCII.Cell(convertible: failure.reason.error.yellowText))
                renderer += ASCII.Row(ASCII.Cell(convertible: failure.reason.description ?? unknowDescription))
                renderer += ASCII.Separator()
            }
            
            if let error = self.response.error {
                renderer += ASCII.Row(ASCII.Cell(convertible: error.localizedDescription))
                renderer += ASCII.Separator()
            }
        }
        
        /* ----------------------------------------
         ** Attach authentication method used for
         ** this request. Either a certificate or
         ** an authentication token.
         */
        switch self.credentials {
        case .certificate(let certificate):
            renderer += ASCII.Row(ASCII.Cell(convertible: "Certificate".yellowText))
            renderer += ASCII.Row(ASCII.Cell(convertible: certificate.label))
        case .authenticationCredentials(let credentials):
            renderer += ASCII.Row(ASCII.Cell(convertible: "Authentication Token".yellowText))
            renderer += ASCII.Row(ASCII.Cell(convertible: "File:".lightBlueText    + " " + credentials.privateKey.lastPathComponent))
            renderer += ASCII.Row(ASCII.Cell(convertible: "Team ID:".lightBlueText + " " + credentials.teamIdentifier))
            renderer += ASCII.Row(ASCII.Cell(convertible: "Key ID:".lightBlueText  + " " + credentials.keyIdentifier))
        }
        renderer += ASCII.Separator()
        
        /* ----------------------------------------
         ** Attach headers used for this request.
         */
        let headers = self.request.headers.dictionary
        
        renderer += ASCII.Row(ASCII.Cell(convertible: "Request Metadata".yellowText))
        renderer += headers.map {
            ASCII.Row(ASCII.Cell(convertible: "\($0.key): ".lightBlueText + $0.value))
        }
        renderer += ASCII.Separator()
        
        /* ----------------------------------------
         ** Attach the payload JSON.
         */
        renderer += ASCII.Row(ASCII.Cell(convertible: "Payload".yellowText))
        if let url = self.request.payload.url {
            renderer += ASCII.Row(ASCII.Cell(convertible: "File:".lightBlueText  + " " + url.lastPathComponent))
        } else {
            let contents = String(data: self.request.payload.contents, encoding: .utf8)!
            renderer += ASCII.Row(ASCII.Cell(convertible: contents))
        }
        renderer += ASCII.Separator()
        
        return "\n" + renderer.render() + "\n"
    }
}
