//
//  OpenSSL.swift
//  Spyder
//
//  Created by Dima Bart on 2018-02-01.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import Foundation
import Cocoa

struct OpenSSL: CryptorType {
    
    let privateKeyURL: URL
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init(privateKey: URL) {
        self.privateKeyURL = privateKey
    }
    
    // ----------------------------------
    //  MARK: - CryptorType -
    //
    func sign(message: Data) -> Data? {
        
        let inPipe = Pipe()
        let handle = inPipe.fileHandleForWriting
        
        let outPipe            = Pipe()
        let process            = Process()
        process.launchPath     = "/usr/bin/openssl"
        process.standardInput  = inPipe
        process.standardOutput = outPipe
        process.arguments      = [
            "dgst",
            "-binary",
            "-sha256",
            "-sign",
            self.privateKeyURL.path,
        ]
        
        process.launch()
        
        handle.write(message)
        handle.closeFile()
        
        process.waitUntilExit()

        return outPipe.fileHandleForReading.readDataToEndOfFile()
    }
}
