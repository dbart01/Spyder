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
//

import Foundation

struct Arguments {
    
    private let arguments: [String : String] = {
        
        let all = ProcessInfo.processInfo.arguments
        if all.count > 1 {
            var container = [String : String]()
            var i = 1
            while i < all.count {
                container[all[i]] = (i + 1 < all.count) ? all[i + 1] : ""
                i += 2
            }
            return container
        }
        return [:]
    }()
    
    var count: Int {
        return self.arguments.count
    }
    
    var help: Bool {
        if let _ = self.args("--help") {
            return true
        }
        return false
    }
    
    var listIdentities: Bool {
        if let _ = self.args("-i", "--identities") {
            return true
        }
        return false
    }
    
    var token: String? {
        if let token = self.args("-t", "--token") {
            return token
        }
        return nil
    }
    
    var port: String? {
        if let port = self.args("-P", "--port") {
            return port
        }
        return nil
    }
    
    var passphrase: String? {
        if let pass = self.args("-p", "--passphrase") {
            return pass
        }
        return nil
    }
    
    var certificatePath: String? {
        if let path = self.args("-c", "--cert") {
            return path
        }
        return nil
    }
    
    var certificateIndex: Int? {
        if let index = self.argi("-c", "--cert") {
            return index
        }
        return nil
    }
    
    var environment: Environment? {
        if let abbreviation = self.args("-e", "--env"),
            let env = Environment(rawValue: abbreviation) {
            
                return env
        }
        return nil
    }
    
    var message: String? {
        if let message = self.args("-m", "--message") {
            return message
        }
        return nil
    }
    
    var topic: String? {
        if let topic = self.args("-T", "--topic") {
            return topic
        }
        return nil
    }
    
    var payload: Data? {
        if let payload = self.args("-L", "--payload") {
            
            if payload.contains("{") {
                return payload.data(using: String.Encoding.utf8)
            } else {
                return (try? Data(contentsOf: URL(fileURLWithPath: (payload as NSString).expandingTildeInPath)))
            }
        }
        return nil
    }
    
    var priority: Int? {
        if let priority = self.argi("--priority") {
            return priority
        }
        return nil
    }
    
    var expiryTimestamp: Int? {
        if let expiry = self.argi("-x", "--expiry") {
            return expiry
        }
        return nil
    }
    
    var id: String? {
        if let id = self.args("-I", "--id") {
            return id
        }
        return nil
    }
    
    var version: Bool {
        if let _ = self.args("-v", "--version") {
            return true
        }
        return false
    }
    
    // ----------------------------------
    //  MARK: - Arguments -
    //
    private func arg(_ keys: [String]) -> String? {
        var value: String?
        for key in keys where value == nil {
            value = self.arguments[key]
        }
        return value
    }
    
    private func args(_ keys: String ...) -> String? {
        return self.arg(keys)
    }
    
    private func argi(_ keys: String ...) -> Int? {
        if let arg = self.arg(keys),
            let int = Int(arg) {
                return int
        }
        return nil
    }
}
