//
//  ProfileController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/08.
//

import UIKit
import RxSwift
import RxCocoa

protocol ProfileViewModelBindable: ViewModelType {
    
}


class ProfileController: UIViewController, ViewType {

    var viewModel: ProfileViewModelBindable!
    var disposeBag: DisposeBag!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
    }
    
    func setupUI() {
        
    }
    
    func bind() {
        
    }

}
