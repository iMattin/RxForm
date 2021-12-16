//
//  RxFormTests.swift
//  RxFormTests
//
//  Created by Matin Abdollahi on 9/1/20.
//  Copyright © 2020 IEM. All rights reserved.
//

import XCTest
import RxSwift
@testable import RxForm

class RxFormTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testValidEmailFormat() {
        let formControl = FormControl("Matin@gmail.com", validators: [Validators.email])
        XCTAssertTrue(formControl.valid, "E-Mail validator failed")
    }
    
    func testInvalidEmailFormat() {
        let formControl = FormControl("matin@gmail", validators: [Validators.email])
        XCTAssertFalse(formControl.valid, "E-Mail validator failed")
    }
    
    func testValidMinLength() {
        let formControl = FormControl("Hello", validators: [Validators.maxLength(6)])
        XCTAssertTrue(formControl.valid, "Min length validator failed")
    }
    
    func testEmptyEmailFormat() {
        let formControl = FormControl("", validators: [Validators.email])
        XCTAssertTrue(formControl.valid, "E-Mail validator failed")
    }
    
    func testNullEmailFormat() {
        let formControl = FormControl(nil, validators: [Validators.email])
        XCTAssertTrue(formControl.valid, "E-Mail validator fail")
    }

    func testRequiredFormControl() {
        let formControl = FormControl("", validators: [Validators.required])
        XCTAssertTrue(formControl.errors["required"] != nil, "Required validator fail")
    }
    
    func testValue() {
        let formControl = FormControl("Matin", validators: [Validators.required])
        XCTAssertEqual(formControl.value as! String, "Matin")
    }
    
    func testFormGroupValidity() {
        let formGroup = FormGroup(controls: [
            "username": FormControl("matin3238@gmail.com", validators: [Validators.email]),
            "password": FormControl("1234", validators: [Validators.required, Validators.minLength(4)])
        ])
        XCTAssertTrue(formGroup.controls["username"]!.valid, "ridi")
    }
    
    func testSetFormControlValue() {
        let formControl = FormControl()
        formControl.setValue("Matin")
        XCTAssertEqual(formControl.value as! String, "Matin")
    }
    
    func testSetFormGroupValue() {
        let formGroup = FormGroup(controls: [
            "username": FormControl("matin3238@gmail.com", validators: [Validators.email]),
            "password": FormControl("1234", validators: [Validators.required, Validators.minLength(4)])
        ])
        formGroup.setValue(["username" : "matin"], options: (false, true))
        XCTAssertFalse(formGroup.valid)
    }
    
    func testValidNestedFormGroups() {
        let innerFormGroup = FormGroup(controls: [
            "username": FormControl("matin3238@gmail.com", validators: [Validators.email]),
            "password": FormControl("1234", validators: [Validators.required, Validators.minLength(4)])
        ])
        let outerFormGroup = FormGroup(controls: [
            "inner": innerFormGroup,
            "toggle": FormControl(true)
        ])
        XCTAssertTrue(outerFormGroup.valid)
    }
    
    func testInValidNestedFormGroups() {
        let innerFormGroup = FormGroup(controls: [
            "username": FormControl("matin.com", validators: [Validators.email]),
            "password": FormControl("1234", validators: [Validators.required, Validators.minLength(4)])
        ])
        let outerFormGroup = FormGroup(controls: [
            "inner": innerFormGroup,
            "toggle": FormControl(true)
        ])
        XCTAssertFalse(outerFormGroup.valid)
    }
    
    func testPendingState() {
        let innerFormGroup = FormGroup(controls: [
            "username": FormControl("matin3238@gmail.com", validators: [Validators.email]),
            "password": FormControl("1234", validators: [Validators.required, Validators.minLength(4)]),
            "toggle": FormControl(true, asyncValidators: [createAsyncValidator(seconds: 3)])
        ])
        let outerFormGroup = FormGroup(controls: [
            "inner": innerFormGroup,
            "toggle": FormControl(true)
        ])
        XCTAssertTrue(outerFormGroup.pending)
    }
    
//    func testStatus() {
//        let expectation = self.expectation(description: "async validators")
//        let asyncValidator = self.createAsyncValidator(seconds: 2)
//        let formControl = FormControl("s", validators: [Validators.required], asyncValidators: [asyncValidator, asyncValidator])
//        _ = formControl.statusChanges.drive (onNext: { (status) in
//            if status == .valid {
//                expectation.fulfill()
//            }
//        })
//        self.waitForExpectations(timeout: 7, handler: nil)
//        XCTAssertFalse(formControl.status == .valid)
//    }
    
    private func createAsyncValidator(seconds: Int) -> AsyncValidator {
        return { (control: AbstractControl) in
            return Single<[String : Any]?>.just(nil)
                .delay(RxTimeInterval.seconds(seconds), scheduler: MainScheduler.instance)
        }
    }
    
}
