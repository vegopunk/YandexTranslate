//
//  TranslatedText.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import Foundation

struct TranslatedText: Codable {
    let code: Int
    let lang: String
    let text: [String]
}

