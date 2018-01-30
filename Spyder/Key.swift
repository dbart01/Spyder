//
//  Key.swift
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

class Key {
    
    let key: SecKey
    
    // ----------------------------------
    //  MARK: - Init -
    //
    convenience init?(path: String) {
        let url = URL(fileURLWithPath: (path as NSString).expandingTildeInPath)
        guard let fileData = try? Data(contentsOf: url) else {
            return nil
        }
        
        guard let content = String(data: fileData, encoding: .utf8) else {
            return nil
        }
        
        self.init(PEM: content)
    }
    
    init?(PEM: String) {
        let base64 = PEM.stripCertificateDelimiters()
        
        guard let keyData = Data(base64Encoded: base64, options: [.ignoreUnknownCharacters]) else {
            return nil
        }
        
        let headerSize = 26 // Fixed ASN.1 header size is 26 bytes
        let length     = keyData.count - headerSize - Int(SecPadding.PKCS1.rawValue)
        let range      = Range(headerSize..<length)
        let rawKeyData = keyData.subdata(in: range)
        
        let attributes: [CFString: CFTypeRef] = [
            kSecAttrKeyType:  kSecAttrKeyTypeEC,
            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
            ]
        
        guard let privateKey = SecKeyCreateWithData(rawKeyData as NSData, attributes as NSDictionary, nil) else {
            return nil
        }
        
        self.key = privateKey
    }
    
    // ----------------------------------
    //  MARK: - Signing -
    //
    func sign(algorithm: SecKeyAlgorithm, message: String) -> Data? {
        guard let messageData = message.data(using: .utf8) else {
            return nil
        }
        return self.sign(algorithm: algorithm, message: messageData)
    }
    
    func sign(algorithm: SecKeyAlgorithm, message: Data) -> Data? {
        guard let signature = SecKeyCreateSignature(self.key, algorithm, message as CFData, nil) else {
            return nil
        }
        
        return signature as Data
    }
}

private extension String {
    func stripCertificateDelimiters() -> String {
        return self.components(separatedBy: .newlines).filter {
            !$0.hasPrefix("---")
        }.joined()
    }
}
