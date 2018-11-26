//
//  TranslateProtocols.swift
//  YandexTranslate
//
//  Created by Денис Попов on 27/11/2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

protocol TranslateViewProtocol: class {
    func swapLanguage()
    func updateChatInputView()
    func chatInputView(setText text: String?)
    func appendNewMessage(_ newMessage: ChatMessage)
    func showAlert(with requestError: TranslateRequestError)
}

protocol TranslatePresenterProtocol: class {
    func endVoiceRecord()
    func startVoiceRecord()
    func swapLanguages()
    func getAvailableLanguages()
    func chatInputView(setText text: String?)
    func translate(_ text: String)
    var currentLanguage: String { get }
    var translateLanguage: String { get }
    var currentLanguageLocalized: String { get }
    func chat(append newMessage: ChatMessage)
    var availableLanguages: AvailableLanguages? { get set }
    func showAlert(with requestError: TranslateRequestError)
    func chatInputView(setSendButtonTypeWith text: String?) -> SendButtonType
    func chatInputView(backgroundColorFor language: String) -> UIColor?
    func configureNewChatMessage(with originalText: String,
                                 originalLanguage: String,
                                 translatedText: TranslatedText) -> ChatMessage
    
}

protocol TranslateConfiguratorProtocol: class {
    func configure(with viewController: TranslateViewController)
}

protocol TranslateInteractorProtocol: class {
    func getAvailableLanguages()
    func endVoiceRecord()
    func startVoiceRecord()
    func translate(text: String, lang: String)
    func detectLanguage(with text: String,
                        hint: String,
                        completion: @escaping (DetectedLanguage) -> ())
}
