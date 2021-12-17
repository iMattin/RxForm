//
//  AbstractControl.swift
//
//  Created by Matin Abdollahi on 1/1/21.
//


import Foundation
import RxSwift
import RxCocoa


public class AbstractControl {

    internal var validators: [Validator]!
    internal var asyncValidators: [AsyncValidator]!
    
    /**
    The current value of the control.
     
    For a `FormControl`, the current value.
    For an enabled `FormGroup`, the values of enabled controls as an object
    with a key-value pair for each member of the group.
     */
    public internal(set) var value: Any?
    
    
    /**
    The validation status of the control.
     
    These status values are mutually exclusive, so a control cannot be
    both valid and invalid or invalid and disabled.
    */
    public private(set) var status: ControlStatus!
    
    
    /**
    A weak reference to the parent control.
    */
    public private(set) var errors: [String : Any?] = [:]
    
    
    /**
    A weak reference to the parent control.
    */
    public private(set) weak var parent: AbstractControl?
    
        
    /**
    A control is `valid` when its `status` is `valid`.
    - returns: True if the control has passed all of its validation tests, false otherwise.
    */
    public var valid: Bool {
        return status == .valid
    }
    
    
    /**
    A control is `pending` when its `status` is `pending`.
    - returns: True if this control is in the process of conducting a validation check, false otherwise.
    */
    public var pending: Bool {
        return status == .pending
    }
    
    
    /**
    A control is `enabled` when its `status` is not `disabled`.
    - returns: True if the control has any status other than `disabled`, false if the status is `disabled`.
    */
    public var enabled: Bool {
        return status != .disabled
    }
    
    
    /**
    A control is `disabled` when its `status` is `disabled`.
    - returns: True if the control is disabled, false otherwise.
    */
    public var disabled: Bool {
        return status == .disabled
    }
    
    
    /**
    A multicasting observable that emits an event every time the value of the control changes, in
    the UI or programmatically. It also emits an event each time you call enable() or disable()
    without passing along (`emitEvent = false`) as a function argument.
    */
    public var valueChanges: Driver<Any?> {
        return _valueRelay.asDriver(onErrorJustReturn: nil)
    }
    
    
    /**
    A multicasting observable that emits an event every time the validation `status` of the control
    recalculates.
    */
    public var statusChanges: Driver<ControlStatus> {
        return _statusRelay.asDriver(onErrorJustReturn: .invalid)
    }
    
    
    internal let _valueRelay = PublishRelay<Any?>()
    internal let _statusRelay = PublishRelay<ControlStatus>()
    
    private var asyncValidationSubscription: Disposable?
    
    init(validators: [Validator] = [], asyncValidators: [AsyncValidator] = []) {
        self.validators = validators
        self.asyncValidators = asyncValidators
    }
    
    
    /**
    Sets the synchronous validators that are active on this control. Calling
    this overwrites any existing synchronous validators.
     
     - warning: When you add or remove a validator at run time, you must call
     `updateValueAndValidity()` for the new validation to take effect.
    */
    public func setValidators(_ validators: [Validator]) {
        self.validators = validators
    }
    
    
    /**
    Sets the asynchronous validators that are active on this control.  Calling
    this overwrites any existing synchronous validators.
     
     - warning: When you add or remove a validator at run time, you must call
     `updateValueAndValidity()` for the new validation to take effect.
    */
    public func setAsycValidators(_ asyncValidators: [AsyncValidator]) {
        self.asyncValidators = asyncValidators
    }
    
    
    /**
    Recalculates the value and validation status of the control.
    By default, it also updates the value and validity of its ancestors.
     
    - warning: When you add or remove a validator at run time, you must call
    `updateValueAndValidity()` for the new validation to take effect.
     
    - parameter options: Configuration options determine how the control propagates changes and emits events
    after updates and validity checks are applied.
    - parameter onlySelf: When true, only update this control. When false or not supplied,
    update all direct ancestors. Default is false.
     
    - parameter emitEvent: When true or not supplied (the default), both the `statusChanges` and
    `valueChanges` observables emit events with the latest status and value when the control is updated.
    When false, no events are emitted.
    */
    public func updateValueAndValidity(options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        updateValue()
        asyncValidationSubscription?.dispose()
        
        if enabled {
            errors = _runValidators()
            status = calculateStatus()
            if status == .valid || status == .pending {
                _runAsyncValidators(emitEvents: options.emitValue)
            }
        }
        
        if options.emitValue {
            _valueRelay.accept(value)
            _statusRelay.accept(status)
        }
        
        if !options.onlySelf {
            parent?.updateValueAndValidity(options: options)
        }
    }
    
    
    /**
    Empties out the synchronous validator list.

    - warning: When you add or remove a validator at run time, you must call
    `updateValueAndValidity()` for the new validation to take effect.
    */
    public func clearValidators() {
        validators = []
    }
    
    
    /**
    Empties out the asynchronous validator list.

    - warning: When you add or remove a validator at run time, you must call
    `updateValueAndValidity()` for the new validation to take effect.
    */
    public func clearAsyncValidators() {
        self.asyncValidators = []
    }
    
    
    /**
     Sets the value of the control. Abstract method (implemented in sub-classes).
    */
    public func setValue(_ value: Any?, options: (onlySelf: Bool, emitValue: Bool)) {
        fatalError()
    }
    
    
    /**
     Resets the value of the control. Abstract method (implemented in sub-classes).
    */
    public func reset(options: (onlySelf: Bool, emitValue: Bool)) {
        fatalError()
    }
    
    
    /**
    Enables the control. This means the control is included in validation checks and
    the aggregate value of its parent. Its status recalculates based on its value and
    its validators.

     By default, if the control has children, all children are enabled.

    - parameter options: Configure options that control how the control propagates changes and
    emits events when marked as untouched
    - parameter onlySelf: When true, mark only this control. When false or not supplied,
    marks all direct ancestors. Default is false.
    - parameter emitEvent: When true or not supplied (the default), both the `statusChanges` and
    `valueChanges`
    observables emit events with the latest status and value when the control is enabled.
     When false, no events are emitted.
    */
    public func enable(options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        status = nil
        if !options.onlySelf { parent?.status = nil }
        updateValueAndValidity(options: options)
    }
    
    
    /**
    Disables the control. This means the control is exempt from validation checks and
    excluded from the aggregate value of any parent. Its status is `disabled`.

    By default, if the control has children, all children are also disabled.

    - parameter options: Configure options that control how the control propagates changes and
    emits events when marked as untouched
    - parameter onlySelf: When true, mark only this control. When false or not supplied,
    marks all direct ancestors. Default is false.
    - parameter emitEvent: When true or not supplied (the default), both the `statusChanges` and
    `valueChanges`
    observables emit events with the latest status and value when the control is enabled.
     When false, no events are emitted.
    */
    public func disable(options: (onlySelf: Bool, emitValue: Bool) = (false, true)) {
        status = .disabled
        updateValueAndValidity(options: options)
    }
    
    
    /**
    - parameter parent: Sets the parent of the control
    */
    func setParent(_ parent: HolderControl) {
        self.parent = parent
    }
    
    internal func updateValue() {
        fatalError()
    }
    
    internal func calculateStatus() -> ControlStatus {
        fatalError()
    }
    
    private func _runValidators() -> [String : Any] {
        var errors: [String : Any] = [:]
        self.validators.forEach { validator in
            if let validationResult = validator(self) {
                errors.merge(validationResult) { (_, newValue) -> Any in return newValue }
            }
        }
        return errors
    }
    
    private func _runAsyncValidators(emitEvents: Bool) {
        guard !asyncValidators.isEmpty else { return }
        status = .pending
        var errors: [String : Any] = [:]
        let observables = asyncValidators.map { [unowned self] in $0(self) }
        let completables = observables.map { observable in
            return observable.do(onSuccess: { validationResult in
                if let unwrappedValidationResult = validationResult {
                    errors.merge(unwrappedValidationResult) { (_, newValue) -> Any in
                        return newValue
                    }
                }
            }).asCompletable()
        }
        asyncValidationSubscription = Completable.concat(completables).subscribe(onCompleted: { [unowned self] in
            self._setAsyncErrors(errors, emitValue: emitEvents)
        })
    }
    
    private func _setAsyncErrors(_ errors: [String : Any?], emitValue: Bool) {
        self.errors = errors
        status = nil
        _updateControlsErrors(emitValue: emitValue)
    }
    
    private func _updateControlsErrors(emitValue: Bool) {
        self.status = calculateStatus()
        if emitValue {
            _statusRelay.accept(status)
        }
        parent?._updateControlsErrors(emitValue: emitValue)
    }
    
}


