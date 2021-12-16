//
//  ControlValueAccessor.swift
//
//  Created by Matin Abdollahi on 1/1/21.
//

import UIKit
import RxSwift
import RxCocoa


public typealias OnChangeBlock = (Any?) -> Void

public protocol ControlValueAccessor: UIView {
    func registerOnChange(_ closure: @escaping OnChangeBlock)
    func write(value: Any?)
    func setEnabledState(_ isEnabled: Bool)
}

extension UITextField: ControlValueAccessor {
    
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
        self.text = value as? String
    }
    
    public func setEnabledState(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    public func bind(bag: DisposeBag) {
        self.rx.text.asDriver().drive { [weak self] (value) in
            self?.onChange?(value)
        }.disposed(by: bag)
    }
    
}

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




extension UISegmentedControl: ControlValueAccessor {
    
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
        self.selectedSegmentIndex = value as? Int ?? 0
    }
    
    public func setEnabledState(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    
    public func bind(bag: DisposeBag) {
        self.rx.selectedSegmentIndex.asDriver().drive { [weak self] (value) in
            self?.onChange?(value)
        }.disposed(by: bag)
    }
    
}

extension UIPickerView: ControlValueAccessor {
    
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
        let selectedItem = value as? (row: Int, component: Int) ?? (0 , 0)
        self.selectRow(selectedItem.row, inComponent: selectedItem.component, animated: true)
    }
    
    public func setEnabledState(_ isEnabled: Bool) {
        self.isUserInteractionEnabled = isEnabled
    }
    
    public func bind(bag: DisposeBag) {
        self.rx.itemSelected.asDriver().drive { [weak self] (value) in
            self?.onChange?(value)
        }.disposed(by: bag)
    }
    
}
