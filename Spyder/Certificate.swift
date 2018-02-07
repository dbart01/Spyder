//
//  Certificate.swift
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

class Certificate {
    
    let label: String
    
    private(set) var certificate: SecCertificate!
    private(set) var identity: SecIdentity!
    
    // ----------------------------------
    //  MARK: - Init -
    //
    convenience init?(path: String, passphrase: String) {
        let url = URL(fileURLWithPath: (path as NSString).expandingTildeInPath)
        guard let certificateData = try? Data(contentsOf: url) else {
            return nil
        }
            
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
        
        guard let identityDictionary = certificates.first as? Dictionary<CFString, Any> else {
            return nil
        }
        
        let identity = identityDictionary[kSecImportItemIdentity] as! SecIdentity
        let label    = identityDictionary[kSecImportItemLabel]    as! String
        
        self.init(label: label, identity: identity)
    }
    
    init?(label: String, identity: SecIdentity) {
        self.label    = label
        self.identity = identity
        
        guard let certificate = self.certificateFor(identity) else {
            return nil
        }
        
        self.certificate = certificate
    }
    
    // ----------------------------------
    //  MARK: - Private -
    //
    private func certificateFor(_ identity: SecIdentity) -> SecCertificate? {
        var certificate: SecCertificate?
        SecIdentityCopyCertificate(identity, &certificate)
        
        return certificate
    }
}
