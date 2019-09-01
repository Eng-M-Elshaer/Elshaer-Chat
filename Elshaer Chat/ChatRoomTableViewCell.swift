//
//  ChatRoomTableViewCell.swift
//  Elshaer Chat
//
//  Created by Mohamed Elshaer on 4/5/19.
//  Copyright © 2019 Mohamed Elshaer. All rights reserved.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    enum messageType {
        case incoming
        case outgoing
    }

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var continer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        continer.layer.cornerRadius = 10
    }
    
    func setMessageData(message:Message){
        
        userName.text = message.senderName
        textView.text = message.textMessage
        
    }
    
    func setTextViewType(type:messageType){
        if type == .incoming {
            stackView.alignment = .leading
            continer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            textView.textColor = .black
            
        } else if type == .outgoing {
            stackView.alignment = .trailing
            continer.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textView.textColor = .white
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
