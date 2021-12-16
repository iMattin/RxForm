//
//  Validators.swift
//
//  Created by Matin Abdollahi on 8/11/21.
//

import Foundation

public struct Validators {
    
    /// Check for value to be not `nil`. If type of `value` is `String`, then it should not be an empty `String`
    public static let `required`: Validator = { (control: AbstractControl) in
        let key = "required"
        let value = control.value
        if value == nil {
            return [key : true]
        }
        if let string = value as? String, string.isEmpty {
            return [key : true]
        }
        return (nil)
    }
    
    public static var email: Validator = { (control: AbstractControl) in
        let key = "email"
        let value = control.value
        guard let string = value as? String, !string.isEmpty else {
            return nil
        }
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        let isValid = NSPredicate(format:"SELF MATCHES %@", emailPattern).evaluate(with: value)
        return (isValid ? nil : [key : true])
    }
    
    public static var minLength: ((Int) -> Validator) = { length in
        return { (control: AbstractControl) in
            let key = "minLength"
            let value = control.value
            guard let string = value as? String else {
                return nil
            }
            return string.count >= length ? nil : [key : true]
        }
    }
    
    public static var maxLength: ((Int) -> Validator) = { length in
        return { (control: AbstractControl) in
            let key = "maxLength"
            let value = control.value
            guard let string = value as? String else {
                return nil
            }
            return string.count <= length ? nil : [key : true]
        }
    }
    
    public static func min<T: Numeric>(_ min: T) -> Validator {
        return { control in
            let key = "min"
            let value = control.value
            guard let number = value as? T else {
                return nil
            }
            return number.magnitude >= min.magnitude ? nil : [key : true]
        }
    }
    
    public static func max<T: Numeric>(_ max: T) -> Validator {
        return { control in
            let key = "max"
            let value = control.value
            guard let number = value as? T else {
                return nil
            }
            return number.magnitude <= max.magnitude ? nil : [key : true]
        }
    }
}

