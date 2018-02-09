//
//  JWT.KeyTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-02-06.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class JWT_KeyTests: XCTestCase {

    func testValues() {
        XCTAssertEqual(JWT.Key.alg.rawValue, "alg")
        XCTAssertEqual(JWT.Key.kid.rawValue, "kid")
        XCTAssertEqual(JWT.Key.cty.rawValue, "cty")
        XCTAssertEqual(JWT.Key.typ.rawValue, "typ")
        XCTAssertEqual(JWT.Key.iss.rawValue, "iss")
        XCTAssertEqual(JWT.Key.sub.rawValue, "sub")
        XCTAssertEqual(JWT.Key.aud.rawValue, "aud")
        XCTAssertEqual(JWT.Key.exp.rawValue, "exp")
        XCTAssertEqual(JWT.Key.nbf.rawValue, "nbf")
        XCTAssertEqual(JWT.Key.iat.rawValue, "iat")
        XCTAssertEqual(JWT.Key.jti.rawValue, "jti")
    }
}
