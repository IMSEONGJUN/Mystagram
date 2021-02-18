//
//  Global+Ext.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import UIKit
import Firebase
import JGProgressHUD
import RxSwift
import RxCocoa

// MARK: - Global function
func isValidEmailAddress(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

func loginCheck() -> Bool {
    return Auth.auth().currentUser != nil
}

