//
//  ImageSelectController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/08.
//

import UIKit
import RxSwift
import RxCocoa

protocol ImageSelectViewModelBindable: ViewModelType {

}

class ImageSelectController: UIViewController, ViewType {

    var viewModel: ImageSelectViewModelBindable!
    var disposeBag: DisposeBag!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }
    
    func setupUI() {
        
    }
    
    func bind() {
        
    }


}
