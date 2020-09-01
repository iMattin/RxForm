//
//  MobileNoValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

struct MobileNumberValidator: Validator {
    
    static var name: String { "mobileNumber" }
    
    func isValid(value: Any) -> Bool {
        guard let value = value as? String else { return true }
        return NSPredicate(format:"SELF MATCHES %@", "^(\\+98|0098|98|0)?9\\d{9}$").evaluate(with: value)
    }
    
}
