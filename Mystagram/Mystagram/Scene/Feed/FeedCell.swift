//
//  FeedCell.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/10.
//

import UIKit
import RxSwift
import RxCocoa

final class FeedCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure() {
        
    }
}
