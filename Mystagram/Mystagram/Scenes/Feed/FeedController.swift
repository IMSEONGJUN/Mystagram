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
    // Input
    
    // Output
    
}

final class FeedController: UIViewController, ViewType {
    
    private lazy var collection = UICollectionView(frame: .zero,
                                                   collectionViewLayout: UIHelper.setFeedCellFlowLayout(in: view))
    
    var viewModel: FeedViewModelBindable!
    var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
        title = "Feed"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(vc: self)
    }
    
    @objc func didTapLogout() {
        AuthManager.shared.doLogout()
            .subscribe { completable in
                switch completable {
                case .completed:
                    self.switchToSomeVC(mainVC: LoginController.create(with: LoginViewModel()))
                case .error(_):
                    print("failed to logout")
                }
            }
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        configureCollectionView()
    }
    
    func configureCollectionView() {
        view.addSubview(collection)
        collection.backgroundColor = .systemBackground
        collection.dataSource = self
        collection.register(FeedCell.self, forCellWithReuseIdentifier: FeedCell.reuseID)
        collection.backgroundColor = .systemBackground
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind() {
        // cell 바인딩 할때 cell 내부에 bind함수를 별도로 만들고 파라미터로 cellData랑 Subject<Void>타입으로 buttonClicked같은 이름으로 받도록 하고 viewModel이 갖고있는 buttonClicked subject를 인자로 넘겨서 cell내부 버튼을 해당 subject에 바인딩해준다.
        // 예전에 내가 쓰던 proxy느낌
        
        
    }

}

extension FeedController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseID, for: indexPath) as! FeedCell
        return cell
    }
}
