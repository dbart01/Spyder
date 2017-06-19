//
//  Credential.swift
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
//  MARK: - IdentityCollection -
//
struct IdentityCollection: CustomDebugStringConvertible {
    
    var count: Int {
        return identities.count
    }
    
    private let identities: [Identity]
    
    // ----------------------------------
    //  MARK: - Init -
    //
    fileprivate init(identities: [Identity]) {
        self.identities = identities
    }
    
    // ----------------------------------
    //  MARK: - Identities -
    //
    func identityAt(_ index: Int) -> Identity {
        return self.identities[index - 1]
    }
    
    fileprivate func identityExistsAt(_ index: Int) -> Bool {
        if index > 0 && index < self.count + 1 {
            return true
        }
        return false
    }
    
    // ----------------------------------
    //  MARK: - Debug -
    //
    var debugDescription: String {
        let collection = Certificate.identityCollection
        
        var string = ""
        for (i, identity) in collection.identities.enumerated() {
            let padding = self.paddingForIndex(i + 1, count: collection.count)
            string += "\(i + 1).\(padding) \(identity.label)\n"
        }
        return string
    }
    
    private func paddingForIndex(_ index: Int, count: Int) -> String {
        var padding = ""
        for _ in 0..<(count / 10) - (index / 10) {
            padding += " "
        }
        return padding
    }
}

// ----------------------------------
//  MARK: - Identity -
//
struct Identity {
    
    let label: String
    let reference: SecIdentity
    
    private let attributes: [String : AnyObject]
    
    // ----------------------------------
    //  MARK: - Init -
    //
    fileprivate init(attributes: [String : AnyObject]) {
        self.attributes = attributes
        self.reference  = attributes[kSecValueRef  as String] as! SecIdentity
        self.label      = attributes[kSecAttrLabel as String] as! String
    }
}

// ----------------------------------
//  MARK: - Certificate -
//
class Certificate {
    
    private(set) var certificate: SecCertificate!
    private(set) var identity: SecIdentity!
    
    static var identityCollection: IdentityCollection = {
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
            let identities         = identityAttributes.map { Identity(attributes: $0) } .sorted { $0.label < $1.label }
            
            return IdentityCollection(identities: identities)
        }
        
        return IdentityCollection(identities: [])
    }()
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init?(path: String, passphrase: String) {
        
        let url = URL(fileURLWithPath: (path as NSString).expandingTildeInPath)
        if let certificateData = try? Data(contentsOf: url) {
            
            let options = [
                kSecImportExportPassphrase as String : passphrase,
            ]
            
            var items: CFArray?
            let result = SecPKCS12Import(certificateData as CFData, options as CFDictionary, &items)
            guard result == errSecSuccess else {
                return nil
            }
            
            guard let certificates = items as Array<AnyObject>?, certificates.count > 0 else {
                return nil
            }
            
            guard let identityDictionary = certificates.first as? Dictionary<String, SecIdentity> else {
                return nil
            }
            
            self.identity    = identityDictionary[kSecImportItemIdentity as String]!
            self.certificate = self.certificateFor(self.identity)
            
        } else {
            return nil
        }
    }
    
    init(identityIndex: Int) {
        
        let collection = Certificate.identityCollection
        
        guard collection.identityExistsAt(identityIndex) else {
            error("Invalid identity index provided.")
        }
        
        self.identity    = collection.identityAt(identityIndex).reference
        self.certificate = self.certificateFor(self.identity)
    }
    
    // ----------------------------------
    //  MARK: - Private -
    //
    private func certificateFor(_ identity: SecIdentity) -> SecCertificate {
        var cert: SecCertificate?
        SecIdentityCopyCertificate(identity, &cert)
        
        guard let certificate = cert else {
            error("Failed to obtain certificate for identity.")
        }
        
        return certificate
    }
}
