//
//  JWT.Token.swift
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

extension JWT {
    struct Token {
        
        var header:  Header
        var payload: Payload
        
        private(set) var signature: String = ""
        
        // ----------------------------------
        //  MARK: - Init -
        //
        init(header: Header = .init(), payload: Payload = .init()) {
            self.header  = header
            self.payload = payload
        }
        
        // ----------------------------------
        //  MARK: - Serialize -
        //
        func serialize() throws -> String {
            if self.signature.isEmpty {
                print("[WARNING] JWT.Token has not been signed.")
            }
            
            let header  = try self.headerBase64()
            let payload = try self.payloadBase64()
            
            return "\(header).\(payload).\(self.signature)"
        }
        
        // ----------------------------------
        //  MARK: - Base64 -
        //
        private func headerBase64() throws -> String {
            return try JSONSerialization.data(withJSONObject: self.header.values, options: []).base64EncodedString()
        }
        
        private func payloadBase64() throws -> String {
            return try JSONSerialization.data(withJSONObject: self.payload.values, options: []).base64EncodedString()
        }
        
        // ----------------------------------
        //  MARK: - Signature -
        //
        mutating
        func sign(using key: PrivateKey) throws {
            let header  = try self.headerBase64()
            let payload = try self.payloadBase64()
            
            let message   = "\(header).\(payload)"
            let signature = key.sign(algorithm: .ecdsaSignatureMessageX962SHA256, message: message)?.base64EncodedString()
            
            guard let encodedSignature = signature else {
                throw Error.signingFailed
            }
            
            self.signature = encodedSignature
        }
    }
}

extension JWT.Token {
    enum Error: Swift.Error {
        case signingFailed
    }
}
