//
//  SendButton.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

enum SendButtonType {
    case recordAudio
    case sendAudio
    case sendText
}

class SendButton: UIButton {
    
    var type: SendButtonType = .recordAudio {
        didSet {
            setImage(by: type)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(by: type)
    }
    
    func setImage(by type: SendButtonType) {
        switch type {
        case .recordAudio:
            setImage(UIImage(named: "recordAudio"), for: .normal)
        case .sendAudio:
            setImage(UIImage(named: "sendAudio"), for: .normal)
        case .sendText:
            setImage(UIImage(named: "sendButton"), for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        widthAnchor.constraint(equalToConstant: frame.height).isActive = true
    }
    
    
}
