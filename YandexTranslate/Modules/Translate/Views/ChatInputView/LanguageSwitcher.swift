//
//  LanguageSwitcher.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

class LanguageSwitcher: UIButton {
    
    var firstLanguage: UIImageView = UIImageView()
    var secondLanguage: UIImageView = UIImageView()
    private var isInitialPosition: Bool = true
    let padding : CGFloat = 2
    let borderWidth: CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(firstLanguage)
        addSubview(secondLanguage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let allSwitcherPaddings = padding*2 + borderWidth*2
        let heightWithoutPaddings = frame.height - allSwitcherPaddings
        widthAnchor.constraint(equalToConstant: ((heightWithoutPaddings*4)/3) + allSwitcherPaddings).isActive = true
        
        layer.cornerRadius = frame.height / 2
        setCornerRadius(for: firstLanguage)
        setCornerRadius(for: secondLanguage)
        let imageWidth: CGFloat = frame.height - padding*2
        firstLanguage.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: 0), size: CGSize(width: imageWidth, height: imageWidth))
        secondLanguage.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: padding, left: 0, bottom: padding, right: padding), size: CGSize(width: imageWidth, height: imageWidth))
    }
    
    func swapLanguages() {
        DispatchQueue.main.async {
            let translationX = (self.frame.height - self.borderWidth*2 - self.padding*2)/3
            let transform = self.isInitialPosition ? CGAffineTransform(translationX: translationX, y: 0) : .identity
            self.isInitialPosition ? self.bringSubviewToFront(self.firstLanguage) : self.sendSubviewToBack(self.firstLanguage)
            self.performAnimations(with: transform)
            self.isInitialPosition = !self.isInitialPosition
        }
    }
    
    private func performAnimations(with transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.50, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.firstLanguage.transform = transform
            self.secondLanguage.transform = transform.inverted()
        })
    }
    
    private func setCornerRadius(for imageView: UIImageView) {
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = (frame.height - 4) / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
