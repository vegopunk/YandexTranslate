//
//  TranslatePresenter.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

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
            self.view.updateChatInputView()
        }
    }
    
    func showAlert(with requestError: TranslateRequestError) {
        view.showAlert(with: requestError)
    }
    
    func startVoiceRecord() {
        interactor.startVoiceRecord()
    }
    
    func endVoiceRecord() {
        interactor.endVoiceRecord()
    }
    
    func chatInputView(setText text: String?) {
        view.chatInputView(setText: text)
    }
    
    func chatInputView(backgroundColorFor language: String) -> UIColor? {
        switch language {
        case "en":
            return .aqua
        case "ru":
            return .pink
        default:
            return nil
        }
    }
    
    func chatInputView(setSendButtonTypeWith text: String?) -> SendButtonType {
        return text?.count ?? 0 > 0 ? .sendText : .recordAudio
    }
    
    func swapLanguages() {
        self.useLanguages.swapAt(0, 1)
        self.view.swapLanguage()
    }
    
    func translate(_ text: String) {
        interactor.detectLanguage(with: text, hint: useLanguages.joined(separator: ",")) { (detectedLanguage) in
            if detectedLanguage.lang != self.currentLanguage &&
                self.useLanguages.contains(detectedLanguage.lang) {
                self.swapLanguages()
            }
            self.interactor.translate(text: text, lang: self.translateLanguage)
        }
    }
    
    func getAvailableLanguages() {
        interactor.getAvailableLanguages()
    }
    
    func configureNewChatMessage(with originalText: String,
                                 originalLanguage: String,
                                 translatedText: TranslatedText
        ) -> ChatMessage {
        let color = chatInputView(backgroundColorFor: originalLanguage)
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
                return [.layerMaxXMinYCorner,
                        .layerMinXMinYCorner,
                        .layerMaxXMaxYCorner]
            case .right:
                return [.layerMinXMaxYCorner,
                        .layerMaxXMinYCorner,
                        .layerMinXMinYCorner]
            default:
                return [.layerMaxXMinYCorner,
                        .layerMinXMinYCorner,
                        .layerMaxXMaxYCorner,
                        .layerMinXMaxYCorner]
            }
        }
        let newChatMessage = ChatMessage.init(originalText: originalText,
                                              originalLanguage: originalLanguage,
                                              translatedText: translatedText,
                                              alignment: alignement,
                                              backgroundColor: color,
                                              cornerAngles: cornerAngles)
        return newChatMessage
    }
    
    func chat(append newMessage: ChatMessage) {
        view.appendNewMessage(newMessage)
    }
    
}
