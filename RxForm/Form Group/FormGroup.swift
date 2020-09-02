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
        self._formChanges.flatMapLatest {
            Observable<Bool>.combineLatest(self._controls.values.map { $0.validityChanges }) { (elements) -> Bool in
                elements.allSatisfy { $0 }
            }
        }.share(replay: 1, scope: .whileConnected)
    }()
    
    private var _controls: [String : FormControlProtocol] { didSet { self._formChanges.accept(()) } }
    private let _formChanges = BehaviorRelay<Void>(value: ())
    
    public init(controls: [String : FormControlProtocol]) {
        self._controls = controls
    }
    
    public func addControl(key: String, field: FormControlProtocol) {
        self._controls[key] = field
    }
    
    public func removeControl(forKey key: String) {
        self._controls.removeValue(forKey: key)
    }
    
    public func reset() {
        for control in (self._controls) {
            control.value.reset()
        }
    }
    
    public func getControl<T>(_ t: T.Type, forKey key: String) -> FormControl<T> {
        return _controls[key]! as! FormControl<T>
    }
    
    public func updateValueAndValidity() {
        for control in (self._controls) {
            control.value.updateValueAndValidity()
        }
    }

}
