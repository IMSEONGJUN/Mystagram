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
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 0)
    }
    
    init(placeHolder: String) {
        super.init(frame: .zero)
        borderStyle = .none
        backgroundColor = UIColor(white: 1, alpha: 0.7)
        keyboardAppearance = .dark
        returnKeyType = .done
        autocorrectionType = .no
        attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                   attributes: [.foregroundColor : UIColor.lightGray])
        textColor = .white
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
}
