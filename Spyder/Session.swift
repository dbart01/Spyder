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

import Foundation

// ----------------------------------
//  MARK: - Request -
//
class Request: NSMutableURLRequest {
    
    var payload:           NSData?
    var method:            String               = "GET"
    var additionalHeaders: [String : String]    = [:]
    
    private func build() {
        self.HTTPMethod = self.method
        self.HTTPBody   = self.payload
        
        for (header, value) in self.additionalHeaders {
            self.setValue(value, forHTTPHeaderField: header)
        }
    }
}

// ----------------------------------
//  MARK: - Session -
//
class Session: NSObject {
    
    let certificate: Certificate
    
    var session: NSURLSession!
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(certificate: Certificate) {
        self.certificate = certificate
        
        super.init()
        
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(), delegate: self, delegateQueue: nil)
    }
    
    // ----------------------------------
    //  MARK: - Request Execution -
    //
    func executeRequest(request: Request) -> Response? {
        
        request.build()
        
        var response: Response?
        
        let semaphore = dispatch_semaphore_create(0)
        let dataTask = self.session.dataTaskWithRequest(request) { (data, urlResponse, error) in
            response = Response(response: urlResponse as? NSHTTPURLResponse, data: data, error: error)
            dispatch_semaphore_signal(semaphore)
        }
        dataTask.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        
        return response
    }
    
    func executeJsonRequest(request: Request) -> JsonResponse? {
        if let response = self.executeRequest(request) {
            return JsonResponse(response: response.response, data: response.data, error: response.error)
        }
        return nil
    }
}

extension Session: NSURLSessionDelegate {
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {

        let credentials = NSURLCredential(identity: self.certificate.identity, certificates: [self.certificate.certificate], persistence: .ForSession)
        completionHandler(.UseCredential, credentials)
    }
}
