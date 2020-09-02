//
//  FormField.swift
//  FormExample
//
//  Created by Matin Abdollahi on 5/12/20.
//  Copyright © 2020 TESTAPP. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


public protocol FormControlProtocol {
    func reset()
    var validityChanges: Observable<Bool> { get }
    func updateValueAndValidity()
}


public class FormControl<T>: FormControlProtocol {


    public var value: T {
        get {
            try! self._subject.value()
        }
        set {
            self._subject.onNext(newValue)
        }
    }
    
    public var valueChanges: Observable<T> {
        self._subject.asObservable()
    }

    public lazy var validityChanges: Observable<Bool> = {
        self._subject
            .flatMap { [unowned self] value -> Observable<Bool> in
                Observable<Bool>.just(self.applyValidators())
            }.share(replay: 1, scope: .whileConnected)
    }()
    
    
    internal let _subject: BehaviorSubject<T>
    internal let _initialValue: T

    private let _validators: [SyncValidator<T>]
    private let _errors: ReplaySubject<Validation>
    private let _bag = DisposeBag()
    
    

    public init(initialValue: T, validators: [SyncValidator<T>] = []) {
        self._initialValue = initialValue
        self._validators = validators
        self._subject = BehaviorSubject(value: initialValue)
        self._errors = .createUnbounded()
        self.observeValidityChanges()
    }
    
    public func hasError(_ name: String) -> Observable<Bool> {
        self._errors.filter { $0.name == name }.map { $0.isValid }
    }

    public func reset() {
        self._subject.onNext(self._initialValue)
    }
    
    public func updateValueAndValidity() {
        self._subject.onNext(self.value)
    }

    private func observeValidityChanges() {
        self.validityChanges.subscribe().disposed(by: self._bag)
    }
    
    private func applyValidators() -> Bool {
        var isAllValid = true
        self._validators.forEach { validator in
            let validation = validator(value)
            self._errors.onNext(validation)
            if !validation.isValid { isAllValid = false }
        }
        return isAllValid
    }
}
