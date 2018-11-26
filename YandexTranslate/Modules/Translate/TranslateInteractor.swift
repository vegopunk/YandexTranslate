//
//  TranslateInteractor.swift
//  YandexTranslate
//
//  Created by Денис Попов on 26/11/2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import Foundation
import Moya

protocol TranslateInteractorProtocol: class {
    func detectLanguage(with text: String, completion: @escaping (DetectedLanguage) -> ())
    func getLanguages()
    func translate(text: String, lang: String)
}

class TranslateInteractor {
    weak var presenter: TranslatePresenterProtocol!
    let translateProvider = MoyaProvider<TranslateService>()
    
    required init(presenter: TranslatePresenterProtocol) {
        self.presenter = presenter
    }
    
}

//MARK: - TranslateInteractorProtocol
extension TranslateInteractor: TranslateInteractorProtocol {
    func detectLanguage(with text: String, completion: @escaping (DetectedLanguage) -> ()) {
        translateProvider.request(.detectLanguage(text: text, hint: "ru,en"), callbackQueue: DispatchQueue.global(qos: .background)) { (result) in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {return}
                guard let detectedLanguage = try? JSONDecoder().decode(DetectedLanguage.self, from: response.data) else {return}
                completion(detectedLanguage)
            case .failure(_):
                break
            }
        }
    }
    
    func getLanguages() {
        translateProvider.request(.getLangs(ui: "ru"), callbackQueue: DispatchQueue.global(qos: .background)) { (result) in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {return}
                guard let availableLanguages = try? JSONDecoder().decode(AvailableLanguages.self, from: response.data) else {return}
                self.presenter.availableLanguages = availableLanguages
            case .failure(_):
                break
            }
        }
    }
    
    func translate(text: String, lang: String) {
        translateProvider.request(.translate(text: text, lang: lang), callbackQueue: DispatchQueue.global(qos: .background)) { (result) in
            switch result {
            case .success(let response):
                guard response.statusCode == 200 else {return}
                guard let translatedText = try? JSONDecoder().decode(TranslatedText.self, from: response.data) else {return}
                let newMessage = self.presenter.configureNewChatMessage(with: text, originalLanguage: self.presenter.currentLanguage, translatedText: translatedText)
                self.presenter.appendNewChatMessage(newMessage)
            case .failure(_):
                break
            }
        }
    }
}
