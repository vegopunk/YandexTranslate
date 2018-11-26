//
//  ChatMessageCell.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var message: ChatMessage! {
        didSet {
            let mutableAttributedText = NSMutableAttributedString(string: message.originalLanguage, attributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium), .foregroundColor: UIColor(white: 1, alpha: 0.8)])
            mutableAttributedText.append(NSAttributedString(string: "\n" + message.translatedText, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .medium), .foregroundColor: UIColor.white]))
            
            messageLabel.attributedText = mutableAttributedText
            messageLabel.textAlignment = message.alignment
            
            switch message.alignment {
            case .left:
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            default:
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }

            bubbleBackgroundView.backgroundColor = message.backgroundColor
            bubbleBackgroundView.layer.maskedCorners = message.cornerAngles
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rotate()
        separatorInset = .init(top: 0, left: 500, bottom: 0, right: 0)
        backgroundColor = .clear
        bubbleBackgroundView.layer.cornerRadius = 16
        
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .white
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        
        // lets set up some constraints for our label
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -10),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -12),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 12),
            ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        trailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
