//
//  MobileNoValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

public struct MobileNumberValidator {
    
    public static var name: String { "mobileNumber" }
    
    public init() {}
    
    public func isValid(value: String?) -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", "^(\\+98|0098|98|0)?9\\d{9}$").evaluate(with: value)
    }
}
