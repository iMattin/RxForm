//
//  Validator.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation
import RxSwift


public struct Validation {
    let name: String
    let isValid: Bool
}

public typealias SyncValidator<T> = (T) -> (Validation)


public struct Validators {
    public static var required: SyncValidator<String?> = {
        .init(name: "required", isValid: $0 != nil && !$0!.isEmpty)
    }
    
    public static var email: SyncValidator<String?> = {
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        return .init(name: "email", isValid: NSPredicate(format:"SELF MATCHES %@", emailPattern).evaluate(with: $0))
    }
    
    public static var maxLength: (Int) -> SyncValidator<String?> = { length in
        { .init(name: "required", isValid: $0 != nil && $0!.count <= length) }
    }

    public static var minLength: (Int) -> SyncValidator<String?> = { length in
        { .init(name: "required", isValid: $0 != nil && $0!.count >= length) }
    }
    
    public static var req: SyncValidator<Any> = {
        if case Optional<Any>.none = $0 {
            return .init(name: "required", isValid: false)
        } else {
            return .init(name: "required", isValid: true)
        }
        
    }
}
