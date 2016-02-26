//
//  Help.swift
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

let HelpContents = [
    
    "",
    "Usage: spyder --token #token# --cert #cert-path# --topic #bundle-id# --message \"Hello World!\"",
    "Options, required field marked with [x]:",
    " [x] -t, --token      Hex value of a device token",
    " [ ] -P, --port       Port to use for the endpoint: 443 or 2197, defaults to 443",
    " [ ] -p, --passphrase Passphrase to use for certificate, if required",
    " [x] -c, --cert       Path to certificate to use for the connection",
    " [ ] -e, --env        Indicates whether to use the sandbox environment or not. Options are: dev, prod",
    " [-] -m, --message    Convenience for creating a payload with a message. Ignored if payload is provided",
    " [-] -L, --payload    A JSON string representing the payload, or path to file with JSON payload",
    " [x] -T, --topic      Topic for which to send push. Often a bundle id in the form of 'com.company.app.voip'",
    
].joinWithSeparator("\n")