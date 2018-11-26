//
//  ViewController.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

protocol TranslateViewProtocol: class {
    func appendNewMessage(_ newMessage: ChatMessage)
}

class TranslateViewController: UIViewController {
    
    private let footerViewHeight: CGFloat = 76
    
    var chat = ChatTableView()
    var chatInputView = ChatInputView()
    
    var presenter: TranslatePresenterProtocol!
    let configurator = TranslateConfigurator()

    var chatMessages = [ChatMessage]() {
        didSet {
            DispatchQueue.main.async {
                self.chat.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationCenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationCenter()
    }

    //MARK: - Fileprivate Methods
    private func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(chat)
        chat.fillSafeAreaSuperview()
    }
    
}

extension TranslateViewController: TranslateViewProtocol {
    func appendNewMessage(_ newMessage: ChatMessage) {
        print("appendNewMessage")
        self.chatMessages.insert(newMessage, at: 0)
    }
}

//MARK: - UITableViewDelegate
extension TranslateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return footerViewHeight
    }
    
}

//MARK: - UITableViewDataSource
extension TranslateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseId, for: indexPath) as! MessageCell
        cell.message = chatMessages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.addSubview(chatInputView)
        chatInputView.fillSafeAreaSuperview(padding: UIEdgeInsets(top: 16, left: 4, bottom: 16, right: 4))
        return headerView
    }
    
}

//MARK: - ChatInputViewDelegate
extension TranslateViewController: ChatInputViewDelegate {
    
    func chatInputView(_ chatInputView: ChatInputView, editingChanged textField: MessageTextField) {
//        chatInputView.sendButton.type = presenter.sendButtonType(by: textField.text)
        chatInputView.update()
    }
    
    func chatInputView(_ chatInputView: ChatInputView, sendButtonDidSelect sendButton: SendButton) {
        switch sendButton.type {
        case .recordAudio:
            sendButton.type = .sendAudio
            chatInputView.textField.isEnabled = false
            chatInputView.switcher.isEnabled = false
        case .sendAudio:
            sendButton.type = .recordAudio
            chatInputView.textField.isEnabled = true
            chatInputView.switcher.isEnabled = true
        default:
            let newMessage = ChatMessage.init(originalLanguage: "Some original text", translatedText: "Some translated text", alignment: .right, backgroundColor: .aqua, cornerAngles: [.layerMaxXMinYCorner, .layerMinXMinYCorner , .layerMaxXMaxYCorner])
            appendNewMessage(newMessage)
        }
        chatInputView.update()
    }
    
    func chatInputView(_ chatInputView: ChatInputView, switcherDidSelect switcher: LanguageSwitcher) {
        switcher.swapLanguages()
        presenter.swapLanguages()
        chatInputView.update()
    }
    
}

//MARK: - ChatInputViewDataSource
extension TranslateViewController: ChatInputViewDataSource {
    
    func chatInputView(_ chatInputview: ChatInputView, typeSendButton sendButton: SendButton) -> SendButtonType {
        switch sendButton.type {
        case .sendAudio:
            return .sendAudio
        default:
            return presenter.sendButtonType(by: chatInputview.textField.text)
        }
    }
    
    func chatInputView(_ chatInputView: ChatInputView, placeholderFor textField: MessageTextField) -> String? {
        switch chatInputView.sendButton.type {
        case .sendAudio:
            return "Говорите..."
        default:
            return textField.isEditing ? "Введите текст" : presenter.currentLanguageLocalized
        }
    }
    
    func chatInputViewColor(_ chatInputView: ChatInputView) -> UIColor? {
        return presenter.viewBackgroundColor()
    }
    
}


//MARK:- NotificationCenter

extension TranslateViewController {
    
    fileprivate func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        let safeAreaBottomHeight : CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        let frame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.chatInputView.update()
        UIView.animate(withDuration: duration) {
            self.chat.contentInset = UIEdgeInsets(top: frame.height - safeAreaBottomHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        let duration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        self.chatInputView.update()
        UIView.animate(withDuration: duration) {
            self.chat.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    fileprivate func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
