//
//  UIColor.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    open class var aqua: UIColor {
        return UIColor.rgb(red: 0, green: 124, blue: 233, alpha: 1.0)
    }
    
    open class var pink: UIColor {
        return UIColor.rgb(red: 237, green: 76, blue: 92, alpha: 1.0)
    }
    
}
