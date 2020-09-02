//
//  MaxLenValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

public struct MaxLengthValidator {
    
    public static var name: String { "maxLen" }

    let maxLen: Int
    
    public init(_ len: Int) {
        self.maxLen = len
    }
    
    public func isValid(value: String?) -> Bool {
//        return value!.count <= self.maxLen
        
        return true
    }
    
}
