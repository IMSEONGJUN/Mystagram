//
//  NotiController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/08.
//

import UIKit
import RxSwift
import RxCocoa

protocol NotiViewModelBindable: ViewModelType {
    
}


class NotiController: UIViewController, ViewType {

    var viewModel: NotiViewModelBindable!
    var disposeBag: DisposeBag!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
    
    func setupUI() {
        
    }
    
    func bind() {
        
    }


}
