//
//  FeedCell.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/10.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let userNameButton: UIButton = {
       let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("venom", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        return btn
    }()
    
    private let postImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private let likeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let commentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let shareButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "1 like"
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "test caption text here"
        return label
    }()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func configureUI() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
            $0.width.height.equalTo(40)
        }
        profileImageView.layer.cornerRadius = 40 / 2
        
        contentView.addSubview(userNameButton)
        userNameButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.width)
        }
    }
    
    func bind(profileButtonTapped: PublishSubject<Void>) {
        
    }
}
