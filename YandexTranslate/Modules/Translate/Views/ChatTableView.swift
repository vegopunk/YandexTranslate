//
//  MessagesTableView.swift
//  YandexTranslate
//
//  Created by PopovD on 26.11.2018.
//  Copyright © 2018 PopovD. All rights reserved.
//

import UIKit

class ChatTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        rotate()
        separatorColor = .clear
        keyboardDismissMode = .onDrag
        register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
