//
//  String+Render.swift
//  Spyder
//
//  Created by Dima Bart on 2018-01-22.
//  Copyright © 2018 Dima Bart. All rights reserved.
//

import Foundation

extension String {
    
    func multiply(by value: Int) -> String {
        var container = self
        for _ in 1..<value {
            container += self
        }
        return container
    }
}
