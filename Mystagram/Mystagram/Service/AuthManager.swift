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
    func performRegistration(values: RegisterInfo) -> Completable {
        return Completable.create { completable -> Disposable in
            Auth.auth().createUser(withEmail: values.email, password: values.password) { (result, error) in
                if let error = error {
                    print("failed to create User: ", error)
                    completable(.error(error))
                    return
                }
                self.saveImageToFirebase(values: values)
                    .subscribe { com in
                        switch com {
                        case .completed:
                            completable(.completed)
                        case .error(let err):
                            completable(.error(err))
                        }
                    }
                    .disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
        
    }
    
    private func saveImageToFirebase(values: RegisterInfo) -> Completable {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = values.profileImage?.jpegData(compressionQuality: 0.75) ?? Data()
        
        return Completable.create { completable -> Disposable in
            ref.putData(imageData, metadata: nil) { (_, error) in
                if let error = error {
                    completable(.error(error))
                    return
                }
                
                ref.downloadURL { (url, error) in
                    if let error = error {
                        completable(.error(error))
                        return
                    }
                    
                    let imageUrl = url?.absoluteString ?? ""
                    self.saveInfoToFirestore(values: values, imageURL: imageUrl)
                        .subscribe { com in
                            switch com {
                            case .completed:
                                completable(.completed)
                            case .error(let err):
                                completable(.error(err))
                            }
                        }
                        .disposed(by: self.disposeBag)
                }
            }
            return Disposables.create()

        }
    }
    
    private func saveInfoToFirestore(values: RegisterInfo, imageURL: String) -> Completable {
        let uid = Auth.auth().currentUser?.uid ?? ""
        
        let docData:[String: Any] = [
            "profileImageURL": imageURL,
            "email": values.email,
            "fullname": values.fullName,
            "userName": values.userName,
            "uid": uid
        ]
        
        return Completable.create { completable -> Disposable in
            Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
                if let error = error {
                    print("failed to save user Info: ", error)
                    completable(.error(error))
                    return
                }
                completable(.completed)
            }
            return Disposables.create()
        }
    }
}
