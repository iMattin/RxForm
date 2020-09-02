//
//  MinLenValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

public struct MinLengthValidator {
    
    public static var name: String { "minLen" }

    
    let minLen: Int
    
    public init(_ len: Int) {
        self.minLen = len
    }
    
    public func isValid(value: String?) -> Bool {
//        guard value != nil else { return false }
//        return value!.count >= self.minLen
        true
    }
}
