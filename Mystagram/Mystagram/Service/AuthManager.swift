//
//  AuthManager.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

final class AuthManager {
    
    static let shared = AuthManager()
    private init() { }
    
    var disposeBag = DisposeBag()
    
    // MARK: - Login
    func performLogin(email: String, password: String) -> Observable<Bool> {
        Observable.create { (observer) -> Disposable in
            Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                if let error = error {
                    observer.onError(error)
                }
                observer.onNext(true)
            }
            
            return Disposables.create{
                observer.onCompleted()
            }
        }
    }
    // MARK: - Logout
    func doLogout() -> Completable {
        return Completable.create { completable -> Disposable in
            do {
                try Auth.auth().signOut()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Registration Logic
    func performRegistration(values: RegisterInfo) -> Observable<Bool> {
        return Observable.create { (observer) -> Disposable in
            Auth.auth().createUser(withEmail: values.email, password: values.password) { (result, error) in
                if let error = error {
                    print("failed to create User: ", error)
                    observer.onNext(false)
                    return
                }
                self.saveInfoToFirestore(values: values)
                    .subscribe(onNext: {
                        observer.onNext($0)
                    })
                    .disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
        
    }
    
    private func saveInfoToFirestore(values: RegisterInfo) -> Observable<Bool> {
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        let docData:[String: Any] = [
            "email": values.email,
            "fullname": values.fullName,
            "userType": values.userType,
            "uid": uid,
        ]
        
        return Observable.create { (observer) -> Disposable in
            Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
                if let error = error {
                    print("failed to save user Info: ", error)
                    observer.onNext(false)
                    return
                }
                observer.onNext(true)
            }
            return Disposables.create()
        }
    }
}
