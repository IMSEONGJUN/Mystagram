//
//  BottomButtonForAuth.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import UIKit

final class GeneralConfirmButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(firstText: String, secondText: String) {
        self.init(frame: .zero)
        configure(firstText: firstText, secondText: secondText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String, color: UIColor ,titleColor: UIColor = UIColor.white) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = color
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = 6
        clipsToBounds = true
        isEnabled = false
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private func configure(firstText: String, secondText: String) {
        let attributedTitle = NSMutableAttributedString(string: firstText,
                                                        attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                                     .foregroundColor : UIColor.white])
        attributedTitle.append(NSAttributedString(string: secondText,
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 16),
                                                               .foregroundColor : UIColor.white]))
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
