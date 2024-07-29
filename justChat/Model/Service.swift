//
//  Service.swift
//  justChat
//
//  Created by Наталья Атюкова on 15.03.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class Service{
    static let shared = Service()
    init() {}
    
    //
    

    
    func createNewUser(_ data: LoginField,  completion: @escaping (ResponseCode) -> ()){
        Auth.auth().createUser(withEmail: data.email, password: data.password) { result, err in
            if err == nil {
                if result != nil {
                    let userId = result?.user.uid
                    let email = data.email
                    let data: [String: Any] = ["email":email]
                    Firestore.firestore().collection("users").document(userId!).setData(data)
                    completion(ResponseCode(code: 1))
                }
            } else {
                completion(ResponseCode(code: 0))
            }
        }
    }
    
    
    func confirmEmail(){
        Auth.auth().currentUser?.sendEmailVerification(completion: { err in
            if err != nil {
                print(err!.localizedDescription)
            }
        })
    }
    
    func authInApp(_ data: LoginField, complection: @escaping (AuthResponce) -> ()){
        Auth.auth().signIn(withEmail: data.email, password: data.password) { result, err in
            if err != nil{
                complection(.error)
            } else {
                if let result = result {
                    if result.user.isEmailVerified { // проверка на подтверждение почты
                        complection(.succes)
                    } else {
                        self.confirmEmail()
                        complection(.noVerify)
                    }
                    
                    
                }
            }
        }
    }
    func getUserStatus(){ // проверяет статус авторизации пользователя на Firebase
        // is isset
        // auth?
    }
    
    
    
    func getAllUsers(completion: @escaping ([CurrentUsers]) -> ()){
        
        guard let email = Auth.auth().currentUser?.email else { return }
        var currentUsers = [CurrentUsers]()
        
        Firestore.firestore().collection("users")
            .whereField("email", isNotEqualTo: email)
            .getDocuments { snap, err in
                if err == nil {
                    if let docs = snap?.documents {
                        for doc in docs {
                            let data = doc.data()
                            let userId = doc.documentID
                            let email = data["email"] as! String
                            currentUsers.append(CurrentUsers(id: userId, email: email))
                        }
                    }
                    completion(currentUsers)
                }
            }
    }
    // addSnapshotListener - просматривает изменения в реальном времени в полях на файрбазе. меняется инф-я в бд и сразу в приложении
    // [weak self] выгружает респонс код если он не вызывается из памяти чтобы не было утечки памяти
    
    
    
    
    //MARK: -- Messenger
    
    func sendMessege(otherID: String?, convoID: String?, text: String, completion: @escaping (String) -> ()) {
        let ref =  Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid{
            if convoID == nil {
                // создаем новую переписку
                let convoID = UUID().uuidString
                let selfData: [String: Any] = [
                    "date": Date(),
                    "otherId": otherID!
                ]
                
                let otherData: [String: Any] = [
                    "date": Date(),
                    "otherId": uid
                ]
                
                // у нас есть переписка с Х
                ref.collection("users")
                    .document(uid)
                    .collection("conversation")
                    .document(convoID)
                    .setData(selfData)
                
                // у Х человека есть переписка с нами
                ref.collection("users")
                    .document(otherID!)
                    .collection("conversation")
                    .document(convoID)
                    .setData(selfData)
                
                
                let msg: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                ]
                
                let convoInfo: [String: Any] = [
                    "date": Date(),
                    "selfSender": uid,
                    "otherSender": otherID!
                ]
                
                ref.collection("conversation")
                    .document(convoID)
                    .setData(convoInfo) { err in
                        if let err = err{
                            print(err.localizedDescription)
                            return
                        }
                        ref.collection("conversation")
                            .document(convoID)
                            .collection("messages")
                            .addDocument(data: msg) { err in
                                if err == nil{
                                    completion(convoID)
                                }
                            }
                        
                    }
                
            } else {
                let msg: [String: Any] = [
                    "date": Date(),
                    "sender": uid,
                    "text": text
                ]
                
                ref.collection("conversation").document(convoID!).collection("messages").addDocument(data: msg) { err in
                    if err == nil{
                        completion(convoID!)
                    }
                }
            }
        }
    }
    
    func updateConvo(){
        
    }
    
    func getConvoID(otherId: String, completion: @escaping (String)->()){
        if let uid = Auth.auth().currentUser?.uid{
            let ref = Firestore.firestore()
            
            ref.collection("users")
                .document(uid)
                .collection("conversation")
                .whereField("otherId", isEqualTo: otherId)
                .getDocuments { snap, err in
                    if err != nil{
                        return
                    }
                    if let snap = snap, !snap.documents.isEmpty{
                        let doc = snap.documents.first
                        if let convoID = doc?.documentID{
                            completion(convoID)
                        }
                    }
                    
                }
        }
    }
    
    func getAllMessage(chatID: String, completion: @escaping ([Message]) -> ()){
        if let uid = Auth.auth().currentUser?.uid{
            let ref = Firestore.firestore()
            ref.collection("conversation")
                .document(chatID)
                .collection("messages")
                .limit(to: 50)
                .order(by: "date", descending: false)
                .addSnapshotListener { snap, err in
                    if err != nil{
                        return
                    }
                    if let snap = snap, !snap.documents.isEmpty{
                        var msgs = [Message]()
                        //Message(sender: selfSender, messageID: "", sentDate: Date(), kind: .text(text))
                        var sender = Sender(senderId: uid, displayName: "Me")
                        for doc in snap.documents{
                            let data = doc.data()
                            let userID = data["sender"] as! String
                            let messageId = doc.documentID
                            let date = data["date"] as! Timestamp
                            let sentDate = date.dateValue()
                            let text = data["text"] as! String
                            
                            if userID == uid{
                                sender = Sender(senderId: "1", displayName: "")
                            } else {
                                sender = Sender(senderId: "2", displayName: "")
                            }
                                
                            msgs.append(Message(sender: sender, messageId: messageId, sentDate: sentDate, kind: .text(text)))
                            
                        }
                        completion(msgs)
                    }
                }
        }
        
        func getOneMessage(){
            
        }
    }
}
