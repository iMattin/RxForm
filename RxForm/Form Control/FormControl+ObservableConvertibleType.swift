//
//  FormControl+ObservableConvertibleType.swift
//  RxForm
//
//  Created by Matin Abdollahi on 9/2/20.
//  Copyright © 2020 IEM. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension FormControl: ObservableConvertibleType {
    public func asObservable() -> Observable<T> {
        self._subject.asObservable()
    }
}


extension FormControl: SharedSequenceConvertibleType {
    public typealias SharingStrategy = DriverSharingStrategy
    public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, T> {
        self._subject.asDriver(onErrorJustReturn: self._initialValue)
    }
}
