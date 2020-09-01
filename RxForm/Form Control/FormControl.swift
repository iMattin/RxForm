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
    var isValid: Observable<Bool> { get }
}


public class FormControl<T>: FormControlProtocol {

    public var currentValue: T {
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

    public lazy var isValid: Observable<Bool> = {
        self._subject.flatMap { [unowned self] value -> Observable<Bool> in
            var isAllValid = true
            self._validators.forEach { validator in
                let isValid = validator.isValid(value: value)
                self._errors[type(of: validator).name]!.accept(!isValid)
                if !isValid { isAllValid = false }
            }
            return Observable<Bool>.just(isAllValid)
        }.share(replay: 1, scope: .whileConnected)
    }()
    
    
    private let _subject: BehaviorSubject<T>
    private let _initialValue: T
    private let _defaultValue: T
    private let _validators: [Validator]
    private let _errors: [String : BehaviorRelay<Bool>]
    private let _bag = DisposeBag()
    
    

    public init(initialValue: T, defaultValue: T, validators: [Validator] = []) {
        self._initialValue = initialValue
        self._defaultValue = defaultValue
        self._validators = validators
        self._subject = BehaviorSubject(value: self._initialValue)
        self._errors = validators.reduce([String : BehaviorRelay<Bool>](), { (dict, validator) -> [String : BehaviorRelay<Bool>] in
            var dict = dict
            dict[type(of: validator).name] = BehaviorRelay<Bool>(value: false)
            return dict
        })
        self.observeChanges()
    }
    
    public func hasError(_ name: String) -> Observable<Bool> {
        self._errors[name]!.asObservable()
    }

    public func reset() {
        self._subject.onNext(self._defaultValue)
    }


    private func observeChanges() {
        self.isValid.subscribe().disposed(by: self._bag)
    }
}



extension FormControl: ObserverType {

    public func on(_ event: Event<T>) {
        switch event {
        case .completed:
            self._subject.onCompleted()
        case let .error(error):
            self._subject.onError(error)
        case let .next(value):
            self._subject.onNext(value)
        }
    }

}


extension FormControl: ObservableConvertibleType {
    public func asObservable() -> Observable<T> {
        self._subject.asObservable()
    }
}



extension FormControl: SharedSequenceConvertibleType {
    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, T> {
        self.asDriver(onErrorJustReturn: _defaultValue)
    }
}


