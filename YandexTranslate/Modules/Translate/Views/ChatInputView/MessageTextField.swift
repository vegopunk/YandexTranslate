//
//  MessageTextField.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

class MessageTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clearButtonMode = .whileEditing
        textColor = .white
        tintColor = .white
        autocorrectionType = .no
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = .white
            }
        }
    }
    
    func setPlaceholder(with value: String) {
        self.attributedPlaceholder = NSAttributedString(string: value, attributes: [.foregroundColor : UIColor(white: 1, alpha: 0.8), .font: UIFont.systemFont(ofSize: 17, weight: .medium)])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
