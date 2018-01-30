//
//  Crypto.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-01-28.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class CryptoTests: XCTestCase {

    func testHash() {
        
        let curve = uECC_secp256r1()!
        
        let publicKey  = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        let privateKey = UnsafeMutablePointer<UInt8>.allocate(capacity: 32)
        let signature = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        
        var message = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}".data(using: .utf8)!
        let data = message.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) in return bytes }
        
        let generateResult = uECC_make_key(publicKey, privateKey, curve)
        let signResult = uECC_sign(privateKey, data, UInt32(message.count), signature, curve)
        let verifyResult = uECC_verify(publicKey, data, UInt32(message.count), signature, curve)
        
        XCTAssertEqual(generateResult, 1)
        XCTAssertEqual(signResult, 1)
        XCTAssertEqual(verifyResult, 1)
        
        print("Signature: \(signature.hash(of: 64))")
    }
}

extension UnsafeMutablePointer where Pointee == UInt8 {
    
    func hash(of length: Int) -> String {
        var characters: [UInt8] = []
        for index in 0..<length {
            characters.append(self[index])
        }
        return String(cString: characters)
    }
}
