//
//  LogoView.swift
//  YandexTranslate
//
//  Created by Денис Попов on 26/11/2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

class LogoView: UIView {
    
    var logo = UIImageView(image: UIImage(named: "yandexLogo"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
//        rotate()
        logo.contentMode = .scaleAspectFit
        addSubview(logo)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logo.centerInSuperview(size: CGSize(width: 0, height: frame.height*0.4))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
