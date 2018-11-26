//
//  ViewController.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {
    
    private let footerViewHeight: CGFloat = 76
    private let logoViewHeight: CGFloat = 52.5
    private let chatInputViewPaddings: UIEdgeInsets = UIEdgeInsets(top: 16,
                                                                   left: 4,
                                                                   bottom: 16,
                                                                   right: 4)
    private var defaultChatContentInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: 0,
                            bottom: logoViewHeight,
                            right: 0)
    }
    
    var chat = ChatTableView()
    var chatInputView = ChatInputView()
    var logoView = LogoView()
    
    var presenter: TranslatePresenterProtocol!
    let configurator = TranslateConfigurator()

    var chatMessages = [ChatMessage]() {
        didSet {
            DispatchQueue.main.async {
                self.chat.reloadData()
            }
        }
    }
    
    //MARK: - Lidecycle Methods
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
        
        chat.contentInset = defaultChatContentInsets
        view.addSubview(chat)
        chat.fillSafeAreaSuperview()
        
        view.addSubview(logoView)
        logoView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                        leading: view.safeAreaLayoutGuide.leadingAnchor,
                        bottom: nil,
                        trailing: view.safeAreaLayoutGuide.trailingAnchor,
                        size: CGSize(width: 0,
                                     height: logoViewHeight))
        
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(row: 0, section: 0)
            self.chat.scrollToRow(at: lastIndexPath,
                                  at: .middle,
                                  animated: true)
        }
    }
    
}

//MARK: - TranslateViewProtocol
extension TranslateViewController: TranslateViewProtocol {
    
    func showAlert(with requestError: TranslateRequestError) {

        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Ошибка",
                                                    message: requestError.message,
                                                    preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Ок", style: .default)
            alertController.addAction(submitAction)
            self.present(alertController, animated: true)
        }
    }
    
    func chatInputView(setText text: String?) {
        self.chatInputView.textField.text = text
    }
    
    func appendNewMessage(_ newMessage: ChatMessage) {
        self.chatMessages.insert(newMessage, at: 0)
    }
    
    func updateChatInputView() {
        DispatchQueue.main.async {
            self.chatInputView.update()
        }
    }
    
    func swapLanguage() {
        self.chatInputView.switcher.swapLanguages()
        self.updateChatInputView()
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
        headerView.backgroundColor = .white
        headerView.addSubview(chatInputView)
        chatInputView.fillSafeAreaSuperview(padding: chatInputViewPaddings)
        return headerView
    }
    
}

//MARK: - ChatInputViewDelegate
extension TranslateViewController: ChatInputViewDelegate {
    
    func chatInputView(_ chatInputView: ChatInputView, editingChanged textField: MessageTextField) {
        updateChatInputView()
    }
    
    func chatInputView(_ chatInputView: ChatInputView, sendButtonDidSelect sendButton: SendButton) {
        switch sendButton.type {
        case .recordAudio:
            sendButton.type = .sendAudio
            chatInputView.textField.isEnabled = false
            chatInputView.switcher.isEnabled = false
            presenter.startVoiceRecord()
        case .sendAudio:
            sendButton.type = .recordAudio
            chatInputView.textField.isEnabled = true
            chatInputView.switcher.isEnabled = true
            presenter.endVoiceRecord()
        default:
            guard let text = chatInputView.textField.text else { return }
            presenter.translate(text)
            chatInputView.textField.text = nil
        }
        updateChatInputView()
    }
    
    func chatInputView(_ chatInputView: ChatInputView, switcherDidSelect switcher: LanguageSwitcher) {
        presenter.swapLanguages()
    }
    
}

//MARK: - ChatInputViewDataSource
extension TranslateViewController: ChatInputViewDataSource {
    
    func chatInputView(_ chatInputview: ChatInputView, typeSendButton sendButton: SendButton) -> SendButtonType {
        switch sendButton.type {
        case .sendAudio:
            return .sendAudio
        default:
            return presenter.chatInputView(setSendButtonTypeWith: chatInputview.textField.text)
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
        return presenter.chatInputView(backgroundColorFor: presenter.currentLanguage)
    }
    
}


//MARK: - NotificationCenter
extension TranslateViewController {
    
    fileprivate func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        let safeAreaBottomHeight : CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
        let safeAreaTopHeight : CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardDuration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        updateChatInputView()
        if chatMessages.count > 0 {
            scrollToBottom()
        }
        UIView.animate(withDuration: keyboardDuration) {
            self.logoView.transform = CGAffineTransform(translationX: 0, y: -self.logoViewHeight - safeAreaTopHeight)
            self.chat.contentInset = UIEdgeInsets(top: keyboardFrame.height - safeAreaBottomHeight,
                                                  left: 0,
                                                  bottom: 0,
                                                  right: 0)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        let keyboardDuration = (notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        updateChatInputView()
        UIView.animate(withDuration: keyboardDuration) {
            self.logoView.transform = .identity
            self.chat.contentInset = self.defaultChatContentInsets
        }
    }
    
    fileprivate func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}
