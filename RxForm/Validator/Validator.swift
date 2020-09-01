//
//  Validator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation

public protocol Validator {
    static var name: String { get }
    func isValid(value: Any) -> Bool
}
