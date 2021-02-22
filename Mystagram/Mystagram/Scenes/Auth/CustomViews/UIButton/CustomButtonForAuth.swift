//
//  CustomButtonForAuth.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import UIKit

final class CustomButtonForAuth: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(firstText: String, secondText: String) {
        self.init(frame: .zero)
        configure(firstText: firstText, secondText: secondText)
    }
    
    private func configure(firstText: String, secondText: String) {
        let attributedTitle = NSMutableAttributedString(string: firstText,
                                                        attributes: [.font: UIFont.systemFont(ofSize: 15),
                                                                     .foregroundColor : UIColor.white])
        attributedTitle.append(NSAttributedString(string: secondText,
                                                  attributes: [.font : UIFont.boldSystemFont(ofSize: 15),
                                                               .foregroundColor : UIColor.white]))
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
