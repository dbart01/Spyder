//
//  Help.swift
//  Spyder
//
//  Created by Dima Bart on 2016-02-26.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

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