//
//  CertificateTests.swift
//  Spyder Tests
//
//  Created by Dima Bart on 2018-02-07.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import XCTest

class CertificateTests: XCTestCase {

    static let bundle          = Bundle(for: CertificateTests.self)
    static let certPath        = CertificateTests.bundle.url(forResource: "private-test-cert",         withExtension: "p12")!.path
    static let invalidCertPath = CertificateTests.bundle.url(forResource: "private-test-cert-invalid", withExtension: "p12")!.path
    
    // ----------------------------------
    //  MARK: - Init -
    //
    func testInit() {
        let certificate = Certificate(path: CertificateTests.certPath, passphrase: "")
        XCTAssertNotNil(certificate)
    }
    
    func testInvalidPath() {
        let certificate = Certificate(path: "/some/path", passphrase: "")
        XCTAssertNil(certificate)
    }
    
    func testInvalidCert() {
        let certificate = Certificate(path: CertificateTests.invalidCertPath, passphrase: "")
        XCTAssertNil(certificate)
    }
}
