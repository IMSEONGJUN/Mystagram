//
//  FeedController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/07.
//

import UIKit
import RxSwift
import RxCocoa

protocol FeedViewModelBindable: ViewModelType {
    
}

class FeedController: UIViewController, ViewType {
    
    var viewModel: FeedViewModelBindable!
    var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
    
    func setupUI() {
        
    }
    
    func bind() {
        
    }

}
