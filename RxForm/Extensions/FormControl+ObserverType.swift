//
//  FormControl+ObserverType.swift
//
//  Created by Matin Abdollahi on 9/2/20.
//

import Foundation
import RxSwift

extension FormControl: ObserverType {
    public func on(_ event: Event<Any?>) {
        switch event {
        case .completed:
            break
        case .error:
            break
        case let .next(value):
            _valueRelay.accept(value)
        }
    }
}
