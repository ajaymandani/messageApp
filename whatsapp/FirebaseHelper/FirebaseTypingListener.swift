//
//  FirebaseTypingListener.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-16.
//

import Foundation
import FirebaseFirestore

class FirebaseTypingListener{
    static let shared = FirebaseTypingListener()
    var typyingListener: ListenerRegistration!
    init(){}
    
    func createTypingObserver(chatRoomId:String,completion:@escaping(_ isTyping:Bool)->Void)
    {
        typyingListener =  firebaseRef(.Typing).document(chatRoomId).addSnapshotListener({ snap, error in
            guard let snapshot = snap else {return}
            
            if snapshot.exists{
                for data in snapshot.data()!
                {
                    if data.key != User.currentId{
                        completion(data.value as! Bool)
                    }
                }
            }else{
                completion(false)
                firebaseRef(.Typing).document(chatRoomId).setData([User.currentId:false])
            }
        })
    }
    
    class func saveTypingCounter(typing:Bool,chatRoomId:String)
    {
        firebaseRef(.Typing).document(chatRoomId).updateData([User.currentId:typing])

    }
    
    func removeTypingListener(){
        self.typyingListener.remove()
    }
}
