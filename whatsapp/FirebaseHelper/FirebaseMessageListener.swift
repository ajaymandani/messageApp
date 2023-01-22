//
//  FirebaseMessageListener.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-15.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
class FirebaseMessageListner{
    static let shared = FirebaseMessageListner()
    private init(){}
    var newChatListner:ListenerRegistration!
    var updatedChatListener:ListenerRegistration!
    func addMessage(message:LocalMessage,memberId:String)
    {
        do{
            let _ = try  firebaseRef(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)

        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    func checkforoldchats(documentid:String,collectionId:String)
    {
        firebaseRef(.Messages).document(documentid).collection(collectionId).getDocuments { snap, error in
            
            guard let doc = snap?.documents else{
                print("no docs")
                return
            }
            
            var oldMessegses = doc.compactMap { queryDocumentSnapshot -> LocalMessage in
                return try! queryDocumentSnapshot.data(as: LocalMessage.self)
            }
            oldMessegses.sort(by: {$0.date < $1.date})
            for messege in oldMessegses{
                RealmManager.shared.saveToRealm(obj: messege)
            }
        }
    }
    
    
    func listenForNewChats(documentId:String,collectionid:String, lastMessageDate:Date){
        newChatListner = firebaseRef(.Messages).document(documentId).collection(collectionid).whereField("date", isGreaterThan: lastMessageDate).addSnapshotListener({ snap, error in
            guard let snapshot = snap else{
                print("no docs")
                return
            }
            
            for change in snapshot.documentChanges{
                if change.type == .added{
                    let result = Result{
                        try? change.document.data(as: LocalMessage.self)
                    }
                    
                    switch(result)
                    {
                    case .success(let messObj):
                        if let message = messObj{
                            RealmManager.shared.saveToRealm(obj: message)
                        }else{
                            print("doc not exisr")
                        }
                    case .failure(let err):
                        print("err \(error?.localizedDescription)")
                    }
                }
            }
            
            
        })
    }
    
    func updateMessageInFirebase(_ message:LocalMessage, memeberIds:[String]){
        let val = ["status":kread,"date":Date()] as [String:Any]
        for userId in memeberIds{
            firebaseRef(.Messages).document(userId).collection(message.chatRoomId).document(message.id).updateData(val)
        }
    }
    
    func removeListener(){
        self.newChatListner.remove()
//        self.updatedChatListener.remove()
    }
}
