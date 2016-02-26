//
//  Response.swift
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

import Foundation

// ----------------------------------
//  MARK: - ResponseType -
//
protocol ResponseType: CustomDebugStringConvertible {
    typealias DataType
    
    var response: NSHTTPURLResponse? { get }
    var data: DataType? { get }
    var error: NSError? { get }
    
    init?(response: NSHTTPURLResponse?, data: NSData?, error: NSError?)
    
    var debugDescription: String { get }
}

extension ResponseType {
    var debugDescription: String {
        var description = "Status:\n"
        
        description += "\t- Code:  "
        if let res = self.response {
            description += "\(res.statusCode)"
        } else {
            description += "n/a"
        }
        description += "\n"
        
        description += "\t- Data:  "
        if let data = self.data {
            description += "\(data)"
        } else {
            description += "n/a"
        }
        description += "\n"
        
        description += "\t- Error: "
        if let error = self.error {
            description += "\(error.localizedDescription)"
        } else {
            description += "n/a"
        }
        description += "\n"
        
        return description
    }
}

// ----------------------------------
//  MARK: - Response -
//
struct Response: ResponseType {
    
    typealias DataType = NSData
    
    let response: NSHTTPURLResponse?
    let data: DataType?
    let error: NSError?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init?(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) {
        if response == nil && data == nil && error == nil {
            return nil
        }
        
        self.response = response
        self.error    = error
        self.data     = data
    }
}

// ----------------------------------
//  MARK: - JsonResponse -
//
struct JsonResponse: ResponseType {
    
    typealias DataType = [String : AnyObject]
    
    let response: NSHTTPURLResponse?
    let data: DataType?
    let error: NSError?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    init?(response: NSHTTPURLResponse?, data: NSData?, error: NSError?) {
        if response == nil && data == nil && error == nil {
            return nil
        }
        
        self.response = response
        self.error    = error
        
        if let data = data {
            self.data = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String : AnyObject]
        } else {
            self.data = nil
        }
    }
}