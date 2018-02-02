//
//  Session.swift
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

class Session {
    
    let credentials: Credentials
    
    private let session:  URLSession
    private let delegate: SessionDelegate?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(credentials: Credentials) {
        self.credentials  = credentials
        let configuration = URLSessionConfiguration.ephemeral
        
        switch credentials {
        case .certificate(let certificate):
            
            self.delegate = SessionDelegate(certificate: certificate)
            self.session  = URLSession(
                configuration: configuration,
                delegate:      self.delegate,
                delegateQueue: nil
            )
            
//        case .authenticationToken(let privateKey):
        case .authenticationCredentials(let authCredentials):
            
            var token                   = JWT.Token()
            token.header  [JWT.Key.alg] = "ES256"
            token.header  [JWT.Key.kid] = authCredentials.keyIdentifier
            token.payload [JWT.Key.iss] = authCredentials.teamIdentifier
            token.payload [JWT.Key.iat] = Int(Date().timeIntervalSince1970)
            
            let tws = try! token.sign(using: authCredentials.privateKey)
            
            configuration.httpAdditionalHeaders = [
                "Authorization": "Bearer \(tws)"
            ]
            
            self.delegate = nil
            self.session  = URLSession(configuration: configuration)
        }
    }
    
    // ----------------------------------
    //  MARK: - Request Execution -
    //
    func execute(request: Request) -> Response? {
        var response: Response?
        
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = self.session.dataTask(with: request.build()) { data, urlResponse, error in
            response = Response(
                response: urlResponse as? HTTPURLResponse,
                data:     data,
                error:    error
            )
            semaphore.signal()
        }
        
        dataTask.resume()
        semaphore.wait()
        
        return response
    }
}

private class SessionDelegate: NSObject, URLSessionDelegate {
    
    let certificate: Certificate
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(certificate: Certificate) {
        self.certificate = certificate
    }
    
    // ----------------------------------
    //  MARK: - URLSessionDelegate -
    //
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        let credentials = URLCredential(identity: self.certificate.identity, certificates: [self.certificate.certificate], persistence: .forSession)
        completionHandler(.useCredential, credentials)
    }
}
