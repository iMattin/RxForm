//
//  EmailValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation
import RxSwift

public struct EmailValidator {
    
    public static var name: String { "email" }
    
    public init() {}
    
    public func isValid(value: String?) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailPattern).evaluate(with: value)
    }

}

