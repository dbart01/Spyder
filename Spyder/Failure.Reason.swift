//
//  Failure.Reason.swift
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

extension Failure {
    struct Reason {
        
        let error:       String
        let description: String?
        
        // ----------------------------------
        //  MARK: - Init -
        //
        init(error: String) {
            self.error       = error
            self.description = Reason.descriptions[error]
        }
    }
}

// ----------------------------------
//  MARK: - Descriptions -
//
extension Failure.Reason {
    private static var descriptions: [String : String] = [
        "PayloadEmpty"              : "The message payload was empty.",
        "PayloadTooLarge"           : "The message payload was too large. The maximum payload size is 4096 bytes.",
        "BadTopic"                  : "The apns-topic was invalid.",
        "TopicDisallowed"           : "Pushing to this topic is not allowed.",
        "BadMessageId"              : "The apns-id value is bad.",
        "BadExpirationDate"         : "The apns-expiration value is bad.",
        "BadPriority"               : "The apns-priority value is bad.",
        "MissingDeviceToken"        : "The device token is not specified in the request :path. Verify that the :path header contains the device token.",
        "BadDeviceToken"            : "The specified device token was bad. Verify that the request contains a valid token and that the token matches the environment.",
        "DeviceTokenNotForTopic"    : "The device token does not match the specified topic.",
        "Unregistered"              : "The device token is inactive for the specified topic.",
        "DuplicateHeaders"          : "One or more headers were repeated.",
        "BadCertificateEnvironment" : "The client certificate was for the wrong environment.",
        "BadCertificate"            : "The certificate was bad.",
        "Forbidden"                 : "The specified action is not allowed.",
        "BadPath"                   : "The request contained a bad :path value.",
        "MethodNotAllowed"          : "The specified :method was not POST.",
        "TooManyRequests"           : "Too many requests were made consecutively to the same device token.",
        "IdleTimeout"               : "Idle time out.",
        "Shutdown"                  : "The server is shutting down.",
        "InternalServerError"       : "An internal server error occurred.",
        "ServiceUnavailable"        : "The service is unavailable.",
        "MissingTopic"              : "The apns-topic header of the request was not specified and was required. The apns-topic header is mandatory when the client is connected using a certificate that supports multiple topics.",
    ]
}
