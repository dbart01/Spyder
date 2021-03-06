//
//  Headers.swift
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

struct Headers {
    
    let id:       String?
    let topic:    String?
    let priority: Int?
    let expiry:   Int?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(id: String? = nil, topic: String? = nil, priority: Int? = nil, expiry: Int? = nil) {
        self.id       = id
        self.topic    = topic
        self.priority = priority
        self.expiry   = expiry
    }
    
    // ----------------------------------
    //  MARK: - Dictionary -
    //
    var dictionary: [String : String] {
        var container: [String : String] = [:]
        
        if let value = self.id       { container[Key.id]       = value }
        if let value = self.topic    { container[Key.topic]    = value }
        if let value = self.priority { container[Key.priority] = String(describing: value) }
        if let value = self.expiry   { container[Key.expiry]   = String(describing: value) }
        
        return container
    }
}

// ----------------------------------
//  MARK: - Keys -
//
extension Headers {
    enum Key {
        static let id       = "apns-id"
        static let topic    = "apns-topic"
        static let priority = "apns-priority"
        static let expiry   = "apns-expiry"
    }
}
