//
//  ViewType.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/06.
//

import UIKit
import RxSwift

// MARK: - BaseView Protocol

protocol ViewType: AnyObject {
    
    associatedtype VM
    
    var viewModel: VM! { get set }
    var disposeBag: DisposeBag! { get set }
    func setupUI()
    func bind()
}

extension ViewType where Self: UIViewController {
    static func create(with viewModel: VM) -> Self {
        let `self` = Self()
        
        // DI
        self.viewModel = viewModel
        
        // Initial Setup
        self.disposeBag = DisposeBag()
        self.loadViewIfNeeded()
        self.setupUI()
        self.bind()
        return self
    }
}


