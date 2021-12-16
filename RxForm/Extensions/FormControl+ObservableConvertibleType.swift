//
//  FormControl+ObservableConvertibleType.swift
//
//  Created by Matin Abdollahi on 9/2/20.
//

import Foundation
import RxSwift
import RxCocoa

extension FormControl: ObservableConvertibleType {
    public func asObservable() -> Observable<Any?> {
        self._valueRelay.asObservable()
    }
}


extension FormControl: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Any?> {
        self._valueRelay.asDriver(onErrorJustReturn: self.value)
    }
}
