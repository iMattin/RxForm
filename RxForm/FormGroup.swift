//
//  FormGroup.swift
//
//  Created by Matin Abdollahi on 1/1/21.
//

import Foundation
import RxSwift

public protocol HolderControl: AbstractControl {
    var controls: [String : AbstractControl] { get }
}

public class FormGroup: AbstractControl, HolderControl {
    
    public private(set) var controls: [String : AbstractControl] = [:]
    
    public init(controls: [String : AbstractControl], validators: [Validator] = [], asyncValidators: [AsyncValidator] = []) {
        super.init(validators: validators, asyncValidators: asyncValidators)
        self.controls = controls
        controls.values.forEach { $0.setParent(self) }
        self.updateValueAndValidity(options: (true, false))
    }
    
    override public func setValue(_ value: Any?, options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        guard let dict = value as? [String : Any?] else { return }
        for (key , value) in dict {
            self.controls[key]?.setValue(value, options: (true, emitValue: options.emitValue))
        }
        self.updateValueAndValidity(options: options)
    }
    
    /**
     Add control as a child of this control
    - parameter name: Name of control
    - parameter control: Any sub-class of `AbstractControl`
    */
    public func addControl(name: String, control: AbstractControl) {
        control.setParent(self)
        controls[name] = control
        updateValueAndValidity(options: (false, true))
    }
    
    /**
     Find and return an `AbstractControl` in children
     
    - parameter controlName: Name of control
    */
    public func get(_ controlName: String) -> AbstractControl {
        guard let control = controls[controlName] else { fatalError("Control with name \(controlName) not found") }
        return control
    }
    
    /**
     Find and return a nested `AbstractControl` in children
     
    - parameter controlNames: Array of control names
    */
    public func get(_ controlNames: String...) -> AbstractControl {
        var controlNames = controlNames
        let lastControlName = controlNames.popLast()
        var control: HolderControl = self
        for name in controlNames {
            control = control.controls[name] as! HolderControl
        }
        return control.controls[lastControlName!]!
    }
    
    public override func enable(options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        controls.values.forEach { $0.enable(options: (true, true)) }
        super.enable(options: options)
    }
    
    public override func disable(options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        controls.values.forEach { $0.disable(options: (true, true)) }
        super.disable(options: options)
    }
    
    override func updateValue() {
        var dict: [String : Any?] = [:]
        for (name, control) in self.controls {
            if control.enabled {
                dict[name] = control.value
            }
        }
        self.value = dict
    }
    
    override func calculateStatus() -> ControlStatus {
        if status == .disabled { return .disabled }
        if !errors.isEmpty { return .invalid }
        if areAllControlsDisabled() { return .disabled }
        if anyControlHasStatus(.pending) { return .pending }
        if anyControlHasStatus(.invalid) { return .invalid }
        return .valid
    }
    
    private func areAllControlsDisabled() -> Bool {
        for control in controls.values {
            if control.status != .disabled { return false }
        }
        return true
    }
    
    private func anyControlHasStatus(_ status: ControlStatus) -> Bool {
        for control in controls.values {
            if control.status == status { return true }
        }
        return false
    }
}
