//
//  InputTextField.swift
//  Mystagram
//
//  Created by SEONGJUN on 2021/02/17.
//

import UIKit

final class InputTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        returnKeyType = .done
        autocorrectionType = .no
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [.foregroundColor : UIColor.white])
        textColor = .white
        font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
}