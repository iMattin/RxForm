//
//  MinLenValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

struct MinLengthValidator: Validator {
    
    static var name: String { "minLen" }

    
    let minLen: Int
    
    init(_ len: Int) {
        self.minLen = len
    }
    
    func isValid(value: Any) -> Bool {
        guard let value = value as? String else { return true }
        return value.count >= self.minLen
    }
}
