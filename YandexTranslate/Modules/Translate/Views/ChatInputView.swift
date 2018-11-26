//
//  MessageInputView.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

protocol ChatInputViewDataSource: class {
    func chatInputView(_ chatInputView: ChatInputView, placeholderFor textField: MessageTextField) -> String?
    func chatInputViewColor(_ chatInputView: ChatInputView) -> UIColor?
    func chatInputView(_ chatInputview: ChatInputView, typeSendButton sendButton: SendButton) -> SendButtonType
}

protocol ChatInputViewDelegate: class {
    func chatInputView(_ chatInputView: ChatInputView, editingChanged textField: MessageTextField)
    func chatInputView(_ chatInputView: ChatInputView, sendButtonDidSelect sendButton: SendButton)
    func chatInputView(_ chatInputView: ChatInputView, switcherDidSelect switcher: LanguageSwitcher)
}

class ChatInputView: UIView {
    
    private let padding: CGFloat = 2
    
    var textField = MessageTextField()
    var sendButton = SendButton()
    var switcher = LanguageSwitcher()
    
    weak var dataSource: ChatInputViewDataSource?
    weak var delegate: ChatInputViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .aqua
        rotate()
        setupStackView()
        setupDelegateMethods()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
    
    func update() {
        DispatchQueue.main.async {
            let newPlaceholder = self.dataSource?.chatInputView(self, placeholderFor: self.textField) ?? ""
            self.textField.setPlaceholder(with: newPlaceholder)
            self.backgroundColor = self.dataSource?.chatInputViewColor(self)
            let newSendButtonType = self.dataSource?.chatInputView(self, typeSendButton: self.sendButton) ?? .recordAudio
            self.sendButton.type = newSendButtonType
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Support Methods
extension ChatInputView {
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [switcher, textField, sendButton])
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        addSubview(stackView)
        stackView.fillSafeAreaSuperview()
    }
    
    private func setupDelegateMethods() {
        self.textField.addTarget(self, action: #selector(textFieldDidChangeEditing), for: .editingChanged)
        self.sendButton.addTarget(self, action: #selector(sendButtonDidSelect), for: .touchUpInside)
        self.switcher.addTarget(self, action: #selector(switcherDidSelect), for: .touchUpInside)
    }
    
    @objc private func textFieldDidChangeEditing(_ textField: MessageTextField) {
        self.delegate?.chatInputView(self, editingChanged: textField)
    }
    
    @objc private func sendButtonDidSelect(_ sendButton: SendButton) {
        self.delegate?.chatInputView(self, sendButtonDidSelect: sendButton)
    }
    
    @objc private func switcherDidSelect(_ switcher: LanguageSwitcher) {
        self.delegate?.chatInputView(self, switcherDidSelect: switcher)
    }
    
}
