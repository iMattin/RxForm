//
//  RequiredValidator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

public struct RequiredValidator {

    public static var name: String { "required" }

    public init() {}
    
    public func isValid(value: String?) -> Bool {
        true
    }
}

