//
//  MaxLenValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

struct MaxLengthValidator: Validator {
    
    static var name: String { "maxLen" }

    let maxLen: Int

    init(_ len: Int) {
        self.maxLen = len
    }
    
    func isValid(value: Any) -> Bool {
        guard let value = value as? String else { return true }
        return value.count <= self.maxLen
    }
}
