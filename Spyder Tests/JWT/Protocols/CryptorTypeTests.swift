//
//  CryptorTypeTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-02-07.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class CryptorTypeTests: XCTestCase {

    // ----------------------------------
    //  MARK: - Message Sign -
    //
    func testSignStringMessage() {
        let cryptor   = PassthroughCryptor()
        let message   = "Some message"
        let data      = cryptor.sign(message: message)!
        let signature = String(data: data, encoding: .utf8)!
        
        XCTAssertEqual(message, signature)
    }
}

private class PassthroughCryptor: CryptorType {
    
    func sign(message: Data) -> Data? {
        return message
    }
}
