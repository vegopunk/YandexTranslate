//
//  ChatMessage.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

struct ChatMessage {
    let originalText: String
    let originalLanguage: String
    let translatedText: TranslatedText
    let alignment: NSTextAlignment
    let backgroundColor: UIColor?
    let cornerAngles: CACornerMask
}
