//
//  TranslatePresenter.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

protocol TranslatePresenterProtocol: class {
    var currentLanguage: String { get }
    var translateLanguage: String { get }
    var currentLanguageLocalized: String { get }
    var availableLanguages: [String: String]? { get set }
    func viewBackgroundColor() -> UIColor?
    func sendButtonType(by text: String?) -> SendButtonType
    func swapLanguages()
    func detectLanguage(for text: String) -> DetectedLanguage
    func translate(_ text: String) -> TranslatedText
    func getAvailableLanguages()
    
}

class TranslatePresenter: TranslatePresenterProtocol {
    
    weak var view: TranslateViewProtocol!
    
    private var useLanguages: [String] = ["ru", "en"]
    
    var currentLanguage: String {
        return useLanguages[0]
    }
    
    var currentLanguageLocalized: String {
        return self.availableLanguages?[currentLanguage] ?? ""
    }
    
    var translateLanguage: String {
        return useLanguages[1]
    }
    
    var availableLanguages: [String: String]?
    
    func viewBackgroundColor() -> UIColor? {
        switch currentLanguage {
        case "en":
            return .aqua
        default:
            return .pink
        }
    }
    
    func sendButtonType(by text: String?) -> SendButtonType {
        return text?.count ?? 0 > 0 ? .sendText : .recordAudio
    }
    
    func swapLanguages() {
        self.useLanguages.swapAt(0, 1)
    }
    
    func detectLanguage(for text: String) -> DetectedLanguage {
        print("TODO: interactor")
        return DetectedLanguage(code: 200, lang: "ru")
    }
    
    func translate(_ text: String) -> TranslatedText {
        print("TODO: translate")
        return TranslatedText(code: 200, lang: "en", text: ["some value"])
    }
    
    func getAvailableLanguages() {
        print("TODO: getAvailableLanguages")
        self.availableLanguages = AvailableLanguages(langs: ["en" : "Английский", "ru": "Русский"]).langs
    }
    
}
