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
    
    let certificate: Certificate
    
    private let session:  URLSession
    private let delegate: SessionDelegate
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(certificate: Certificate) {
        let delegate    = SessionDelegate(certificate: certificate)
        let session     = URLSession(
            configuration: URLSessionConfiguration.ephemeral,
            delegate:      delegate,
            delegateQueue: nil
        )
        
        self.certificate = certificate
        self.session     = session
        self.delegate    = delegate
    }
    
    // ----------------------------------
    //  MARK: - Request Execution -
    //
    private func execute(request: RequestDescription) -> Response? {
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
    
    func execute(request: RequestDescription) -> JsonResponse? {
        if let response: Response = self.execute(request: request) {
            return JsonResponse(
                response: response.response,
                data:     response.data,
                error:    response.error
            )
        }
        return nil
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
