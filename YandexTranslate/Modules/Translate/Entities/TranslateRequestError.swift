//
//  TranslateRequestError.swift
//  YandexTranslate
//
//  Created by Денис Попов on 27/11/2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import Foundation

struct TranslateRequestError: Codable {
    let code: Int
    let message: String
}
