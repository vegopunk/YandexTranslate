//
//  TranslateInteractor.swift
//  YandexTranslate
//
//  Created by Денис Попов on 26/11/2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import Foundation
import Moya
import Speech

class TranslateInteractor {
    
    weak var presenter: TranslatePresenterProtocol!
    fileprivate let translateProvider = MoyaProvider<TranslateService>()
    
    fileprivate lazy var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: self.presenter.currentLanguage))
    fileprivate var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recognitionTask: SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    
    required init(presenter: TranslatePresenterProtocol) {
        self.presenter = presenter
    }
    
}

//MARK: - TranslateInteractorProtocol
extension TranslateInteractor: TranslateInteractorProtocol {
    
    func endVoiceRecord() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    func startVoiceRecord() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default, options: .defaultToSpeaker)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Не удалось настроить аудиосессию")
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Не удалось создать экземпляр запроса")
        }
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) {
            result, error in
            
            var isFinal = false
            
            if result != nil {
                self.presenter.chatInputView(setText: result?.bestTranscription.formattedString)
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) {
            buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Не удается запустить запись.")
        }
    }
    
    func detectLanguage(with text: String,
                        hint: String,
                        completion: @escaping (DetectedLanguage) -> ()) {
        translateProvider.request(.detectLanguage(text: text, hint: hint), callbackQueue: DispatchQueue.global(qos: .background)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode != 200 {
                    guard let error = try? JSONDecoder().decode(TranslateRequestError.self, from: response.data) else { return }
                    self.presenter.showAlert(with: error)
                    return
                }
                guard let detectedLanguage = try? JSONDecoder().decode(DetectedLanguage.self, from: response.data) else { return }
                completion(detectedLanguage)
            case .failure(_):
                break
            }
        }
    }
    
    func getAvailableLanguages() {
        translateProvider.request(.getAvailableLanguages(ui: "ru"), callbackQueue: DispatchQueue.global(qos: .background)) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode != 200 {
                    guard let error = try? JSONDecoder().decode(TranslateRequestError.self, from: response.data) else { return }
                    self.presenter.showAlert(with: error)
                    return
                }
                guard let availableLanguages = try? JSONDecoder().decode(AvailableLanguages.self, from: response.data) else { return }
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
                if response.statusCode != 200 {
                    guard let error = try? JSONDecoder().decode(TranslateRequestError.self, from: response.data) else { return }
                    self.presenter.showAlert(with: error)
                    return
                }
                guard let translatedText = try? JSONDecoder().decode(TranslatedText.self, from: response.data) else { return }
                let newMessage = self.presenter.configureNewChatMessage(with: text,
                                                                        originalLanguage: self.presenter.currentLanguage,
                                                                        translatedText: translatedText)
                self.presenter.chat(append: newMessage)
            case .failure(_):
                break
            }
        }
    }
}
