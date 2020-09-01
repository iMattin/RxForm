//
//  EmailValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

struct EmailValidator: Validator {
    
    static var name: String { "email" }
    
    func isValid(value: Any) -> Bool {
        guard let value = value as? String else { return true }
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailPattern).evaluate(with: value)
    }
}
