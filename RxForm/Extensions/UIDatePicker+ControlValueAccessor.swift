//
//  UIDatePicker+ControlValueAccessor.swift
//  RxForm
//  Created by Matin Abdollahi on 12/23/21.
//  

import UIKit
import RxSwift
import RxCocoa

extension UIDatePicker: ControlValueAccessor {
    
    private struct AssociatedKeys {
        static var onChangeAddress = "onChangeAddress"
    }
    
    var onChange: OnChangeBlock?  {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.onChangeAddress) as? OnChangeBlock
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.onChangeAddress, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func registerOnChange(_ closure: @escaping OnChangeBlock) {
        self.onChange = closure
    }
    
    public func write(value: Any?) {
        self.date = value as? Date ?? Date()
    }
    
    public func setEnabledState(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    public func bind(bag: DisposeBag) {
        self.rx.date.asDriver().drive { [weak self] (value) in
            self?.onChange?(value)
        }.disposed(by: bag)
    }
    
}
