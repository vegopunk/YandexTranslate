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
    var availableLanguages: AvailableLanguages? { get set }
    func viewBackgroundColor(for language: String) -> UIColor?
    func sendButtonType(by text: String?) -> SendButtonType
    func swapLanguages()
    func translate(_ text: String)
    func getAvailableLanguages()
    func configureNewChatMessage(with originalText: String, originalLanguage: String, translatedText: TranslatedText) -> ChatMessage
    func appendNewChatMessage(_ message: ChatMessage)
}

class TranslatePresenter: TranslatePresenterProtocol {
    
    weak var view: TranslateViewProtocol!
    var interactor: TranslateInteractorProtocol!
    
    required init(view: TranslateViewProtocol) {
        self.view = view
    }
    
    private var useLanguages: [String] = ["ru", "en"]
    
    var currentLanguage: String {
        return useLanguages[0]
    }
    
    var currentLanguageLocalized: String {
        return self.availableLanguages?.langs[currentLanguage] ?? ""
    }
    
    var translateLanguage: String {
        return useLanguages[1]
    }
    
    var availableLanguages: AvailableLanguages? {
        didSet {
            self.view.updateInputView()
        }
    }
    
    func viewBackgroundColor(for language: String) -> UIColor? {
        switch language {
        case "en":
            return .aqua
        case "ru":
            return .pink
        default:
            return .aqua
        }
    }
    
    func sendButtonType(by text: String?) -> SendButtonType {
        return text?.count ?? 0 > 0 ? .sendText : .recordAudio
    }
    
    func swapLanguages() {
        self.useLanguages.swapAt(0, 1)
        self.view.swapLanguage()
    }
    
    func translate(_ text: String) {
        interactor.detectLanguage(with: text) { (detectedLanguage) in
            if detectedLanguage.lang != self.currentLanguage && self.useLanguages.contains(detectedLanguage.lang) {
                self.swapLanguages()
            }
            self.interactor.translate(text: text, lang: self.translateLanguage)
        }
    }
    
    func getAvailableLanguages() {
        interactor.getLanguages()
    }
    
    func configureNewChatMessage(with originalText: String, originalLanguage: String, translatedText: TranslatedText) -> ChatMessage {
        let color = viewBackgroundColor(for: originalLanguage)
        var alignement: NSTextAlignment {
            switch originalLanguage {
            case "en":
                return .left
            default:
                return .right
            }
        }
        var cornerAngles: CACornerMask {
            switch alignement {
            case .left:
                return [.layerMaxXMinYCorner, .layerMinXMinYCorner , .layerMaxXMaxYCorner]
            case .right:
                return [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
            default:
                return [.layerMaxXMinYCorner, .layerMinXMinYCorner , .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
        }
        let newChatMessage = ChatMessage.init(originalText: originalText, originalLanguage: originalLanguage, translatedText: translatedText, alignment: alignement, backgroundColor: color, cornerAngles: cornerAngles)
        return newChatMessage
    }
    
    func appendNewChatMessage(_ message: ChatMessage) {
        view.appendNewMessage(message)
    }
    
}
