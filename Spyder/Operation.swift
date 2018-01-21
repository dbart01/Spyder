//
//  Operation.swift
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

class Operation {
    
    private let token:            String
    private let port:             String
    private let environment:      Environment
    private let message:          String?
    private var payload:          Data?
    
    private let certificatePass:  String
    private let certificateIndex: Int?
    private let certificatePath:  String?
    private var certificate:      Certificate!
    
    private let action:           Action
    private let headers:          Headers
    private let endpoint:         Endpoint
    
    private let args = Arguments()
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init() {
        self.token            = self.args.token       ?? ""
        self.certificatePass  = self.args.passphrase  ?? ""
        self.port             = self.args.port        ?? "443"
        self.environment      = self.args.environment ?? .Development
        self.message          = self.args.message
        self.payload          = self.args.payload
        
        self.certificateIndex = self.args.certificateIndex
        self.certificatePath  = self.args.certificatePath
        
        self.action  = Action(args: self.args)
        self.headers = Headers(
            id:       self.args.id,
            topic:    self.args.topic,
            priority: self.args.priority,
            expiry:   self.args.expiryTimestamp
        )
        
        self.endpoint = Endpoint(
            token:       self.token,
            environment: self.environment,
            port:        self.port
        )
        
        /* ----------------------------------------
         ** Apply a default payload with a provided
         ** message if no payload was provided and
         ** message is not nil.
         */
        if let message = self.message, self.payload == nil {
            self.payload = Payload.default(with: message)
        }
    }
    
    // ----------------------------------
    //  MARK: - Execution -
    //
    func execute() throws {
        switch self.action {
        case .help:
            throw Status.info(HelpContents)
            
        case .version:
            throw Status.info(Version)
            
        case .identities:
            throw Status.info(Identity.list().prettyPrinted)
            
        case .push:
            try self.validateToken()
            try self.validatePayload()
            
            try self.loadCertificate()
            
            let session     = Session(certificate: self.certificate)
            let request     = RequestDescription(url: self.endpoint.url, method: "POST")
            request.payload = self.payload
            request.headers = self.headers
            
            if let response = session.execute(jsonRequest: request) {
                success(response)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Certificate -
    //
    private func loadCertificate() throws {
        if let index = self.certificateIndex {
            
            let identities = Identity.list()
            guard index > 0 && index < identities.count else {
                throw Status.error(.invalidCertificateIndex)
            }
            self.certificate = Certificate(identity: identities[index])
            
        } else if let path = self.certificatePath {
            
            if let certificate = Certificate(path: path, passphrase: self.certificatePass) {
                self.certificate = certificate
            } else {
                throw Status.error(.certificateLoadFailed)
            }
            
        } else {
            throw Status.error(.certificateMissing)
        }
    }
    
    // ----------------------------------
    //  MARK: - Validation -
    //
    private func validateToken() throws {
        guard self.token.count > 0 else {
            throw Status.error(.deviceTokenMissing)
        }
    }
    
    private func validatePayload() throws {
        guard let payload = self.payload else {
            throw Status.error(.payloadEmpty)
        }
        
        let sizeInKB = payload.count / 1024
        if sizeInKB > PayloadMaxSize {
            throw Status.error(.payloadTooBig(sizeInKB))
        }
    }
}

// ----------------------------------
//  MARK: - Action -
//
extension Operation {
    enum Action {
        
        case help
        case version
        case identities
        case push
        
        // ----------------------------------
        //  MARK: - Init -
        //
        fileprivate init(args: Arguments) {
            if args.help || args.count < 1 {
                self = .help
            } else if args.version {
                self = .version
            } else if args.listIdentities {
                self = .identities
            } else {
                self = .push
            }
        }
    }
}

// ----------------------------------
//  MARK: - Exit -
//
extension Operation {
    enum Status: Error {
        
        case success
        case info(String)
        case error(Reason)
        
        var code: Int32 {
            switch self {
            case .success:           return 0
            case .info:              return 200
            case .error(let reason): return reason.code
            }
        }
    }
}

// ----------------------------------
//  MARK: - Reason -
//
extension Operation {
    enum Reason {
        
        case deviceTokenMissing
        case payloadEmpty
        case payloadTooBig(Int)
        case invalidCertificateIndex
        case certificateMissing
        case certificateLoadFailed
        
        var code: Int32 {
            switch self {
            case .deviceTokenMissing:      return 100
            case .payloadEmpty:            return 101
            case .payloadTooBig:           return 102
            case .invalidCertificateIndex: return 103
            case .certificateMissing:      return 104
            case .certificateLoadFailed:   return 105
            }
        }
        
        var description: String {
            switch self {
            case .deviceTokenMissing:            return "Device token missing."
            case .payloadEmpty:                  return "Payload is empty."
            case .payloadTooBig(let actualSize): return "Payload size exceeds maximum, expected: \(PayloadMaxSize), actual: \(actualSize)."
            case .invalidCertificateIndex:       return "Invalid certificate index."
            case .certificateMissing:            return "Certificate not provided."
            case .certificateLoadFailed:         return "Failed to load certificate."
            }
        }
    }
}
