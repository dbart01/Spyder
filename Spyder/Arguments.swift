//
//  Arguments.swift
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

struct Arguments {
    
    private let args: [String : String] = {
        
        let all = NSProcessInfo.processInfo().arguments
        if all.count > 1 {
            let args = Array(all[1...all.count - 1])
            
            var container = [String : String]()
            for var i = 0; i < args.count; i += 2 {
                container[args[i]] = (i + 1 < args.count) ? args[i + 1] : ""
            }
            return container
        }
        return [:]
    }()
    
    var help: Bool {
        if let _ = self.args["--help"] {
            return true
        }
        return false
    }
    
    var token: String? {
        if let token = self.args["-t"] ?? self.args["--token"] {
            return token
        }
        return nil
    }
    
    var port: String? {
        if let port = self.args["-P"] ?? self.args["--port"] {
            return port
        }
        return nil
    }
    
    var passphrase: String? {
        if let pass = self.args["-p"] ?? self.args["--passphrase"] {
            return pass
        }
        return nil
    }
    
    var certificatePath: String? {
        if let cert = self.args["-c"] ?? self.args["--cert"] {
            return cert
        }
        return nil
    }
    
    var environment: Environment? {
        if let abbreviation = self.args["-e"] ?? self.args["--env"],
            let env = Environment(rawValue: abbreviation) {
            
                return env
        }
        return nil
    }
    
    var message: String? {
        if let message = self.args["-m"] ?? self.args["--message"] {
            return message
        }
        return nil
    }
    
    var topic: String? {
        if let topic = self.args["-T"] ?? self.args["--topic"] {
            return topic
        }
        return nil
    }
    
    var payload: NSData? {
        if let payload = self.args["-L"] ?? self.args["--payload"] {
            
            if payload.containsString("{") {
                return payload.dataUsingEncoding(NSUTF8StringEncoding)
            } else {
                return NSData(contentsOfFile: (payload as NSString).stringByExpandingTildeInPath)
            }
        }
        return nil
    }
}