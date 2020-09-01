//
//  RequiredValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

struct RequiredValidator: Validator {
    
    static var name: String { "required" }

    
    func isValid(value: Any) -> Bool {
        guard let value = value as? String else { return true }
        return !value.isEmpty
    }
}
