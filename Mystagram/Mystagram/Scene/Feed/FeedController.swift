//
//  FeedController.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol FeedViewModelBindable: ViewModelType {
    
}

final class FeedController: UIViewController, ViewType {
    
    private lazy var collection = UICollectionView(frame: .zero, collectionViewLayout: configureFlowLayout())
    
    var viewModel: FeedViewModelBindable!
    var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    func setupUI() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        view.addSubview(collection)
        collection.backgroundColor = .systemBackground
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureFlowLayout() -> UICollectionViewFlowLayout {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let itemsInLine: CGFloat = 1
        let itemSpacing: CGFloat = 0
        let lineSpacing: CGFloat = 0
        let availableWidth = collection.frame.width - ((itemSpacing * (itemsInLine - 1)) + (inset.left + inset.right))
        let itemWidth = availableWidth / itemsInLine
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = itemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = inset
        layout.estimatedItemSize = CGSize(width: itemWidth, height: itemWidth + 40 + 8 + 8 + 110)
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        return layout
    }
    
    func bind() {
        
    }

}
