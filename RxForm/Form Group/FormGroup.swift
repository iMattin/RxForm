//
//  FormGroup.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa




public class FormGroup {
    
    public lazy var isValid: Observable<Bool> = {
        Observable<Bool>.combineLatest(self._fields.values.map { $0.isValid }) { (elements) -> Bool in
            elements.allSatisfy { $0 }
        }.share()
    }()
    
    private var _fields: [String : FormControlProtocol]

    
    public init(fields: [String : FormControlProtocol]) {
        self._fields = fields
    }
    
    public func addField(key: String, field: FormControlProtocol) {
        self._fields[key] = field
    }
    
    public func reset() {
        for field in (_fields) {
            field.value.reset()
        }
    }
    
    public func getField<T>(_ t: T.Type, key: String) -> FormControl<T> {
        return _fields[key]! as! FormControl<T>
    }

}
