//
//  SearchController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/08.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchViewModelBindable: ViewModelType {

}

class SearchController: UIViewController, ViewType {

    var viewModel: SearchViewModelBindable!
    var disposeBag: DisposeBag!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
    
    func setupUI() {
        
    }
    
    func bind() {
        
    }


}
