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
    private var payload:          Payload?
    
    private let certificatePass:  String
    private let certificateIndex: Int?
    private let certificatePath:  String?
    private let authTokenPath:    String?
    private let keyID:            String?
    private let teamID:           String?
    
    private var credentials:      Session.Credentials!
    
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
        self.environment      = self.args.environment ?? .development
        self.message          = self.args.message
        
        self.certificateIndex = self.args.certificateIndex
        self.certificatePath  = self.args.certificatePath
        self.authTokenPath    = self.args.authKeyPath
        self.keyID            = self.args.keyID
        self.teamID           = self.args.teamID
        
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
        if let payload = Payload(self.args.payload) {
            self.payload = payload
        } else if let message = self.message {
            self.payload = Payload(message: message)
        }
    }
    
    // ----------------------------------
    //  MARK: - Execution -
    //
    func execute() throws {
        switch self.action {
        case .help:
            throw Status.success(Strings.help)
            
        case .version:
            throw Status.success(Strings.version)
            
        case .identities:
            throw Status.success(Identity.list().prettyPrinted)
            
        case .push:
            try self.validateToken()
            try self.validatePayload()
            
            try self.loadCredentials()
            
            let session     = Session(credentials: self.credentials)
            let request     = Request(url: self.endpoint.url, method: "POST", payload: self.payload!, headers: self.headers)
            if let response = session.execute(request: request) {
                let report = Report(
                    request:     request,
                    response:    response,
                    credentials: self.credentials
                )
                throw Status.success(report.generate())
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Credentials -
    //
    private func loadCredentials() throws {
        if let index = self.certificateIndex {
            
            let identities = Identity.list()
            guard index > 0 && index < identities.count else {
                throw Status.error(.invalidCertificateIndex)
            }
            
            let identity = identities[index]
            guard let certificate = Certificate(label: identity.label, identity: identity.reference) else {
                throw Status.error(.certificateLoadFailed)
            }
            
            self.credentials = .certificate(certificate)
            
        } else if let path = self.certificatePath {
            
            if let certificate = Certificate(path: path, passphrase: self.certificatePass) {
                self.credentials = .certificate(certificate)
            } else {
                throw Status.error(.certificateLoadFailed)
            }
            
        } else if let path = self.authTokenPath,
            let keyID = self.keyID,
            let teamID = self.teamID {
            
            let credentials = AuthenticationCredentials(
                privateKey:     URL(fileURLWithPath: path),
                keyIdentifier:  keyID,
                teamIdentifier: teamID
            )
            self.credentials = .authenticationCredentials(credentials)
            
//            if let privateKey = PrivateKey(path: path) {
//                self.credentials = .authenticationToken(privateKey)
//            } else {
//                throw Status.error(.authTokenLoadFailed)
//            }
            
        } else {
            throw Status.error(.credentialsMissing)
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
        
        let sizeInKB = payload.contents.count / 1024
        if sizeInKB > Request.maximumPayloadSize {
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
        
        case success(String)
        case error(Reason)
        
        var code: Int32 {
            switch self {
            case .success:           return 0
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
        case credentialsMissing
        case certificateLoadFailed
        case authTokenLoadFailed
        
        var code: Int32 {
            switch self {
            case .deviceTokenMissing:      return 100
            case .payloadEmpty:            return 101
            case .payloadTooBig:           return 102
            case .invalidCertificateIndex: return 103
            case .credentialsMissing:      return 104
            case .certificateLoadFailed:   return 105
            case .authTokenLoadFailed:     return 106
            }
        }
        
        var description: String {
            switch self {
            case .deviceTokenMissing:            return "Device token missing."
            case .payloadEmpty:                  return "Payload is empty."
            case .payloadTooBig(let actualSize): return "Payload size exceeds maximum, expected: \(Request.maximumPayloadSize), actual: \(actualSize)."
            case .invalidCertificateIndex:       return "Invalid certificate index."
            case .credentialsMissing:            return "Certificate or authentication token not provided."
            case .certificateLoadFailed:         return "Failed to load certificate."
            case .authTokenLoadFailed:           return "Failed to load authentication token."
            }
        }
    }
}
