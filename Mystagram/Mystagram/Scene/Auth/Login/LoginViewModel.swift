//
//  LoginViewModel.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

struct LoginViewModel: LoginViewModelBindable {
    
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    let loginButtonTapped = PublishRelay<Void>()
    
    let isLoginCompleted: Signal<Bool>
    let isValidForm: Driver<Bool>
    
    init(_ model: AuthManager = .shared) {
        self.isValidForm = Observable
            .combineLatest(
                email,
                password
            )
            .map {
                isValidEmailAddress(email: $0)
                    && $1.count > 6
            }
            .asDriver(onErrorJustReturn: false)
        
        isLoginCompleted = loginButtonTapped
            .withLatestFrom(
                Observable.combineLatest(email, password)
            )
            .flatMapLatest {
                model.performLogin(email: $0, password: $1)
            }
            .asSignal(onErrorJustReturn: false)
    }
}
