//
//  main.swift
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

let args = Arguments()

/* -----------------------------------------
** Present the help ignoring everything else
*/
guard args.help == false && args.count > 0 else {
    success(HelpContents)
}

guard args.listIdentities == false else {
    success(Certificate.identityCollection)
}

/* ----------------------------------------
** Required / options arguments
*/
let passphrase  = args.passphrase  ?? ""
let port        = args.port        ?? "443"
let environment = args.environment ?? .Development
let topic       = args.topic
let message     = args.message
var payload     = args.payload

/* ----------------------------------------
** Setup the convenience payload if the
** message was provided and payload wasn't.
*/
if let message = message where payload == nil {
    let dictionary = [
        "aps" : [
            "sound" : "default",
            "alert" : message,
        ]
    ]
    payload = try? NSJSONSerialization.dataWithJSONObject(dictionary, options: [])
}

/* ----------------------------------------
** Load the certificate for authentication
*/
let certificate: Certificate

if let certIndex = args.certificateIndex {
    certificate = Certificate(identityIndex: certIndex)
} else if let certPath = args.certificatePath {
    if let cert = Certificate(path: certPath, passphrase: passphrase) {
        certificate = cert
    } else {
        error("Failed to send push. Could not load the certificate at path: \(certPath)")
    }
} else {
    error("Failed to send push. No certificate provided.")
}

/* ----------------------------------------
** Ensure that we have all the prerequisite
** parameters to execute the push.
*/
guard let token = args.token else {
    error("Failed to send push. No device token provided.")
}

let endpoint = Endpoint(token: token, environment: environment, port: port)
var headers  = [String : String]()

if topic != nil {
    headers["apns-topic"] = topic
}

/* ----------------------------------------
** Build and execute the request via HTTP/2
*/
let session               = Session(certificate: certificate)
let request               = Request(URL: endpoint.url)
request.method            = "POST"
request.payload           = payload
request.additionalHeaders = headers

if let response = session.executeJsonRequest(request) {
    success(response)
}
