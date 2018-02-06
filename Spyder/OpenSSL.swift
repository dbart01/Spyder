//
//  OpenSSL.swift
//  Spyder
//
//  Created by Dima Bart on 2018-02-01.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import Foundation
import Cocoa

enum OpenSSL {
    
    static func sign(using privateKeyURL: URL, message: String) -> Data? {
        return self.sign(using: privateKeyURL, message: message.data(using: .utf8)!)
    }
    
    static func sign(using privateKeyURL: URL, message: Data) -> Data? {
        
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
            privateKeyURL.path,
        ]
        
        process.launch()
        
        handle.write(message)
        handle.closeFile()
        
        process.waitUntilExit()

        return outPipe.fileHandleForReading.readDataToEndOfFile()
    }
}
