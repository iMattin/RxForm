//
//  FormControl+ObserverType.swift
//  RxForm
//
//  Created by Matin Abdollahi on 9/2/20.
//  Copyright © 2020 IEM. All rights reserved.
//

import Foundation
import RxSwift

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
