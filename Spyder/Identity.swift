//
//  Identity.swift
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

struct Identity {
    
    let label:     String
    let reference: SecIdentity
    
    private let attributes: [String : AnyObject]
    
    // ----------------------------------
    //  MARK: - Init -
    //
    static func list() -> [Identity] {
        let query: [String : Any] = [
            kSecMatchLimit       as String : kSecMatchLimitAll,
            kSecClass            as String : kSecClassIdentity,
            kSecAttrAccess       as String : kSecAttrAccessibleWhenUnlocked,
            kSecReturnRef        as String : true,
            kSecReturnAttributes as String : true,
        ]
        
        var items: AnyObject?
        let result = SecItemCopyMatching(query as CFDictionary, &items)
        if result == errSecSuccess && items != nil {
            let identityAttributes = items as! [Dictionary<String,AnyObject>]
            let identities         = identityAttributes.map {
                Identity(attributes: $0)
            }.sorted { $0.label < $1.label }
            
            return identities
        }
        
        return []
    }
    
    private init(attributes: [String : AnyObject]) {
        self.attributes = attributes
        self.reference  = attributes[kSecValueRef  as String] as! SecIdentity
        self.label      = attributes[kSecAttrLabel as String] as! String
    }
}

// ----------------------------------
//  MARK: - Array Pretty Printing -
//
extension Array where Element == Identity {
    var prettyPrinted: String {
        let collection = self
        var string = ""
        for (i, identity) in collection.enumerated() {
            let padding = self.paddingForIndex(i + 1, count: collection.count)
            string += "\(i).\(padding) \(identity.label)\n"
        }
        return string
    }
    
    private func paddingForIndex(_ index: Int, count: Int) -> String {
        var padding = ""
        
        let delta = String(describing: count).count - String(describing: index).count
        for _ in 0..<delta {
            padding += " "
        }
        return padding
    }
}
