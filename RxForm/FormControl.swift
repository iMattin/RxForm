//
//  FormControl.swift
//
//  Created by Matin Abdollahi on 1/1/21.
//

import Foundation
import RxSwift

public class FormControl: AbstractControl {
    
    private weak var _controlValueAccessor: ControlValueAccessor?
    
    public init(_ initValue: Any? = nil, validators: [Validator] = [], asyncValidators: [AsyncValidator] = []) {
        super.init(validators: validators, asyncValidators: asyncValidators)
        self.value = initValue
        self.updateValueAndValidity(options: (true, true))
    }
    
    
    /**
    Sets a new value for the form control.

    - parameter value: The new value for the control.
    - parameter options: Configuration options that determine how the control propagates changes
    and emits events when the value changes.

    - parameter onlySelf: When true, each change only affects this control, and not its parent. Default is false.
    - parameter emitEvent: When true or not supplied (the default), both the `statusChanges` and `valueChanges`
    observables emit events with the latest status and value when the control value is updated.
    When false, no events are emitted.
    */
    public override func setValue(_ value: Any?, options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        self.value = value
        updateValueAndValidity(options: options)
    }

    public override func reset(options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        self.value = nil
        updateValueAndValidity(options: options)
    }
    
    /// Sets a control value accessor to connet UI to the control
    public func setControlValueAccessor(_ accessor: ControlValueAccessor?) {
        _controlValueAccessor = accessor
        accessor?.write(value: value)
        accessor?.setEnabledState(enabled)
        accessor?.registerOnChange({ [weak self] (uiValue) in
            self?.setValueFromUI(uiValue)
        })
    }
    
    public override func enable(options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        super.enable(options: options)
        _controlValueAccessor?.setEnabledState(true)
    }
    
    public override func disable(options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        super.disable(options: options)
        _controlValueAccessor?.setEnabledState(false)
    }

    override func updateValue() {
        _controlValueAccessor?.write(value: value)
    }
    
    override func calculateStatus() -> ControlStatus {
        if !errors.isEmpty { return .invalid }
        return .valid
    }
    
    private func setValueFromUI(_ value: Any?) {
        self.value = value
        self.updateValueAndValidity(options: (false, true))
    }
}




