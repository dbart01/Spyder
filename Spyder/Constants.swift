//
//  Constants.swift
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

let PayloadMaxSize      = 4096

let EndpointDevelopment = "https://api.development.push.apple.com"
let EndpointProduction  = "https://api.push.apple.com"
let EndpointPathPrefix  = "/3/device/"

let HelpContents = [
    
    "",
    "Usage:",
    "",
    " Listing available identities:",
    " spyder --identities",
    "",
    " Sending a push:",
    " spyder --token #token# --cert #cert-path-or-index# --topic #bundle-id# --message \"Hello World!\"",
    "",
    "Options, [x] is required, [-] is alternate, [ ] is optional:",
    "",
    " [ ] -i, --identities  Lists all available identities in the keychain. All other options will be ignored",
    " [x] -t, --token       Hex value of a device token",
    " [ ] -P, --port        Port to use for the endpoint: 443 or 2197, defaults to 443",
    " [ ] -p, --passphrase  Passphrase to use for certificate, if required",
    " [x] -c, --cert        Path to certificate, or index from identities listed using '--identities' option",
    " [ ] -e, --env         \"dev\" or \"prod\" indicating the endpoint to use. Defaults to \"dev\" if not provided",
    " [-] -m, --message     Convenience for creating a payload with a message. Ignored if payload is provided",
    " [-] -L, --payload     A JSON string representing the payload, or path to file with JSON payload",
    " [x] -T, --topic       Topic for which to send push. Often a bundle id in the form of 'com.company.app.voip'",
    " [ ]     --priority    Notification priority is either 10 or 5. Defaults to 10 if not provided",
    " [ ] -x, --expiry      Unix timestamp indicating when the notification expires",
    " [ ] -I, --id          A cononical UUID that idenitifies the notification. Ex: 123e4567-e89b-12d3-a456-42665544000",
    "",
    
].joinWithSeparator("\n")

let ReasonDescriptions = [
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

let StatusDescriptions = [
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