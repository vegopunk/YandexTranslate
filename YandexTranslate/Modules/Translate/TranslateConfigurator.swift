
//
//  TranslateConfigurator.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

class TranslateConfigurator: TranslateConfiguratorProtocol {
    func configure(with viewController: TranslateViewController) {
        
        let presenter = TranslatePresenter(view: viewController)
        let interactor: TranslateInteractorProtocol = TranslateInteractor(presenter: presenter)
        presenter.interactor = interactor
        presenter.getAvailableLanguages()
        
        viewController.presenter = presenter
        
        viewController.chat.delegate = viewController
        viewController.chat.dataSource = viewController
        
        viewController.chatInputView.delegate = viewController
        viewController.chatInputView.dataSource = viewController
        
        viewController.chatInputView.switcher.firstLanguage.image = UIImage(named: presenter.translateLanguage)
        viewController.chatInputView.switcher.secondLanguage.image = UIImage(named: presenter.currentLanguage)
        
        viewController.chatInputView.update()
    }
}
