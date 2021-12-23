//
//  ControlValueAccessor.swift
//
//  Created by Matin Abdollahi on 1/1/21.
//

import UIKit

public typealias OnChangeBlock = (Any?) -> Void

public protocol ControlValueAccessor: UIView {
    func registerOnChange(_ closure: @escaping OnChangeBlock)
    func write(value: Any?)
    func setEnabledState(_ isEnabled: Bool)
}
