//
//  TranslateService.swift
//  YandexTranslate
//
//  Created by Денис Попов on 26/11/2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import Foundation
import Moya

enum TranslateService {
    case getLangs(ui: String?)
    case detectLanguage(text: String, hint: String)
    case translate(text: String, lang: String)
}

extension TranslateService: TargetType {
    var baseURL: URL {
        return URL(string: ServerConfig.url)!
    }
    
    var path: String {
        switch self {
        case .getLangs(_):
            return "/getLangs"
        case .detectLanguage(_):
            return "/detect"
        case .translate(_, _):
            return "/translate"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .getLangs(_), .detectLanguage(_, _):
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getLangs(let ui):
            return .requestParameters(parameters: ["key": ServerConfig.apiKey, "ui": ui ?? ""], encoding: URLEncoding.default)
        case .detectLanguage(let text, let hint):
            return .requestParameters(parameters: ["key": ServerConfig.apiKey, "text": text, "hint": hint], encoding: URLEncoding.default)
        case .translate(let text, let lang):
            return .requestParameters(parameters: ["key": ServerConfig.apiKey, "lang": lang, "text": text], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
