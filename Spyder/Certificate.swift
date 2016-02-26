//
//  Credential.swift
//  Spyder
//
//  Created by Dima Bart on 2016-02-26.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import Foundation

class Certificate {
    
    private(set) var certificate: SecCertificate!
    private(set) var identity: SecIdentity!
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init?(path: String, passphrase: String) {
        
        if let path = path as NSString?,
            let certificateData = NSData(contentsOfFile: path.stringByExpandingTildeInPath) {
            
            let options = [
                kSecImportExportPassphrase as String : passphrase,
            ]
            
            var items: CFArray?
            let result = SecPKCS12Import(certificateData, options, &items)
            guard result == errSecSuccess else {
                return nil
            }
            
            guard let certificates = items as Array<AnyObject>? where certificates.count > 0 else {
                return nil
            }
            
            guard let identityDictionary = certificates.first as? Dictionary<String, SecIdentity> else {
                return nil
            }
            
            self.identity = identityDictionary[kSecImportItemIdentity as String]!
            
            var cert: SecCertificate?
            SecIdentityCopyCertificate(identity, &cert)
            
            self.certificate = cert!
            
        } else {
            return nil
        }
    }
}