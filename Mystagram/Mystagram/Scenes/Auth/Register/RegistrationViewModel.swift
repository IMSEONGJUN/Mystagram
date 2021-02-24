//
//  RegistrationViewModel.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

typealias RegisterInfo = (profileImage: UIImage?, email: String, password: String, fullName: String, userName: String)

struct RegistrationViewModel: RegistrationViewModelBindable {
    
    // MARK: - Properties
    let profileImage = PublishRelay<UIImage?>()
    let email = PublishRelay<String>()
    let fullName = PublishRelay<String>()
    let userName = PublishRelay<String>()
    let password = PublishRelay<String>()
    let signupButtonTapped = PublishRelay<Void>()
    
    let isRegistering: Driver<Bool>
    let isRegistered: Signal<Bool>
    let isFormValid: Driver<Bool>
    
    var disposeBag = DisposeBag()
    
    
    // MARK: - Initializer
    init(_ model: AuthManager = .shared) {
        // Proxy
        let onRegistering = PublishRelay<Bool>()
        isRegistering = onRegistering.asDriver(onErrorJustReturn: false)
        let onRegistered = PublishRelay<Bool>()
        isRegistered = onRegistered.asSignal(onErrorJustReturn: false)
        
        // Validate Registration Values
        let registrationValues = Observable
            .combineLatest(
                profileImage,
                email,
                password,
                fullName,
                userName
            )
            .share()
        
        isFormValid = registrationValues
            .map {
                $0 != nil
                && isValidEmailAddress(email: $1)
                && $2.count > 6
                && $3.count > 3
                && $4.count > 3
            }
            .asDriver(onErrorJustReturn: false)
        
        // Register
        signupButtonTapped
            .withLatestFrom( registrationValues )
            .do(onNext: { _ in
                onRegistering.accept(true)
            })
            .flatMapLatest( model.performRegistration )
            .subscribe { completable in
                switch completable {
                case .completed:
                    onRegistered.accept(true)
                case .error(let err):
                    print("Failed to register: \(err)")
                    onRegistered.accept(false)
                }
                onRegistering.accept(false)
            }
            .disposed(by: disposeBag)
    }
}

