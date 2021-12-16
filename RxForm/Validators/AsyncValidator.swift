//
//  AsyncValidator.swift
//
//  Created by Matin Abdollahi on 1/1/21.
//


import Foundation
import RxSwift

public typealias AsyncValidator = (AbstractControl) -> (Single<[String : Any]?>)
