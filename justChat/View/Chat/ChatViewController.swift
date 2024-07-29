//
//  ChatViewController.swift
//  justChat
//
//  Created by Наталья Атюкова on 21.03.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView

    struct Sender: SenderType{
        var senderId: String
        var displayName: String
    }
    
    struct Message: MessageType{
        var sender: MessageKit.SenderType
        var messageId: String
        var sentDate: Date
        var kind: MessageKit.MessageKind
    }

class ChatViewController: MessagesViewController {
    
    var chatID: String?
    var otherID: String?
    let service: Service.shared
    let selfSender = Sender(senderId: "1", displayName: "Me")
    let otherSender = Sender(senderId: "John", displayName: "You")
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hi")))
        messages.append(Message(sender: otherSender, messageId: "John", sentDate: Date(), kind: .text("Hi")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        showMessageTimestampOnSwipeLeft = true // время по свайпу
    }
}
    
    
extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate, MessagesDataSource {
    
    var currentSender: MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    }

extension ChatViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let msg = Message(sender: selfSender, messageId: "1212", sentDate: Date(), kind: .text(text))
        messages.append(msg) // При нажатии кнопки передает сообщение
        [weak self] service.sendMessege(userID: self.otherID, convoID: <#T##String?#>, message: <#T##Message#>, text: <#T##String#>) { isSend in
            dispatchQueue.main.async{
                inputBar.inputTextView.text = nil
                self?.messagesCollectionView.reloadDataAndKeepOffset()
            }
            
        }
    }
    
    
}
