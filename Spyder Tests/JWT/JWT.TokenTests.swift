//
//  JWT.TokenTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-02-06.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class JWT_TokenTests: XCTestCase {
    
    // ----------------------------------
    //  MARK: - Init -
    //
    func testInit() {
        let token = JWT.Token(
            header:  JWT.Header(values: ["header": "head"]),
            payload: JWT.Payload(values: ["payload": "pay"])
        )
        
        XCTAssertEqual(token.header.count,  1)
        XCTAssertEqual(token.payload.count, 1)
        
        XCTAssertEqual(token.header["header"]   as! String, "head")
        XCTAssertEqual(token.payload["payload"] as! String, "pay")
    }
    
    // ----------------------------------
    //  MARK: - Signature -
    //
    func testValidSignature() {
        let token = JWT.Token(
            header:  JWT.Header(values: ["header": "head"]),
            payload: JWT.Payload(values: ["payload": "pay"])
        )
        
        let cryptor = TestCryptor(signature: "abc123")
        let tws     = try! token.sign(using: cryptor)
        
        let header    = try! JSONSerialization.data(withJSONObject: token.header.values, options: []).base64URL
        let payload   = try! JSONSerialization.data(withJSONObject: token.payload.values, options: []).base64URL
        let signature = "abc123".data(using: .utf8)!.base64URL
        
        XCTAssertEqual(tws, "\(header).\(payload).\(signature)")
    }
    
    func testInvalidSignature() {
        let token = JWT.Token(
            header:  JWT.Header(values: ["header": "head"]),
            payload: JWT.Payload(values: ["payload": "pay"])
        )
        
        let cryptor = TestCryptor(signature: nil)
        
        do {
            _ = try token.sign(using: cryptor)
            XCTFail()
        } catch {
            XCTAssertEqual(error as? JWT.Token.Error, JWT.Token.Error.signingFailed)
        }
    }
}

// ----------------------------------
//  MARK: - TestCryptor -
//
private struct TestCryptor: CryptorType {
    
    let signature: String?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(signature: String?) {
        self.signature = signature
    }
    
    // ----------------------------------
    //  MARK: - CryptorType -
    //
    func sign(message: Data) -> Data? {
        return self.signature?.data(using: .utf8)
    }
}
