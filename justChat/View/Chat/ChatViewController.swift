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
    var service = Service.shared
    let selfSender = Sender(senderId: "1", displayName: "")
    let otherSender = Sender(senderId: "2", displayName: "")
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        showMessageTimestampOnSwipeLeft = true // время по свайпу
        
        //if chatID = nil do find
        if chatID == nil{
            service.getConvoID(otherId: otherID!) { [weak self] chatId in
                self?.chatID = chatId
                self?.getMessages(convoID: chatId)
            }
        }
    }
    
    func getMessages(convoID: String) {
        service.getAllMessage(chatID: convoID) { [weak self] messages in
            self?.messages = messages
            self?.messagesCollectionView.reloadDataAndKeepOffset()
            
        }
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
        let msg = Message(sender: selfSender, messageId: "", sentDate: Date(), kind: .text(text))
        messages.append(msg) // При нажатии кнопки передает сообщение
        service.sendMessege(otherID: self.otherID, convoID: self.chatID, text: text) { [weak self]  isSend in
            DispatchQueue.main.async{
                inputBar.inputTextView.text = nil
                self?.messagesCollectionView.reloadDataAndKeepOffset()
            }
            
        }
    }
    
    
}
