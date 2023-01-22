//
//  FirebaseRecentListener.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-13.
//

import Foundation
import FirebaseFirestore

class FirebaseRecentListner{
    static let shared = FirebaseRecentListner()
    
    private init(){}
    
    func downloadallrecentchatfromfirestore(completion:@escaping(_ allrecent:[RecentChat]?)->Void)
    {
        firebaseRef(.Recent).whereField("senderId", isEqualTo: User.currentId).addSnapshotListener { snap, error in
            
            if error != nil{
                completion(nil)
                return
            }
            
            if snap!.documents.isEmpty{
                completion(nil)
                return
            }
            
            var allrecent:[RecentChat] = []
            let allres = snap!.documents.compactMap { query -> RecentChat in
                return try! query.data(as: RecentChat.self)
                
            }
            
            for res in allres{
                if res.lastmessage != ""{
                    allrecent.append(res)
                }
            }
            
            allrecent = allrecent.sorted(by: {$0.date! > $1.date!})
            
            completion(allrecent)
            
            }
    }
    
    
    
    func addRecent(recent:RecentChat)
    {
        do{
            try firebaseRef(.Recent).document(recent.id).setData(from: recent)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func deleterecent(recent:RecentChat)
    {
        firebaseRef(.Recent).document(recent.id).delete()
    }
    
    
    func resetRecentCounter(chatRoomId:String)
    {
        firebaseRef(.Recent).whereField(KchatroomID, isEqualTo: chatRoomId).whereField("senderId", isEqualTo: User.currentId).getDocuments { snap, err in
            
            guard let doc = snap?.documents else{
                print("no doc found for recent on line 71 recent")
                return
            }
            
            let allRec = doc.compactMap { query -> RecentChat? in
                return try? query.data(as: RecentChat.self)
            }
            
            if allRec.count > 0{
                self.clearunreadCounter(recent: allRec.first!)
            }
            
            
        }
    }
    
    func clearunreadCounter(recent:RecentChat)
    {
        var rec = recent
        rec.unreadCounter = 0
        self.addRecent(recent: rec)
    }
    
    func updateRevents(chatRoomId:String,lastMessafe:String)
    {
        firebaseRef(.Recent).whereField(KchatroomID, isEqualTo: chatRoomId).getDocuments { snap, err in
            guard let doc = snap?.documents else{
                print("no doc")
                return
            }
            let allrecent = doc.compactMap { query -> RecentChat in
                return try!  query.data(as: RecentChat.self)
            }
            
            for rec in allrecent{
                self.updateRecenetItemWithNewMessage(recent: rec, lastMessage: lastMessafe)
            }
            
        }
    }
    
    func updateRecenetItemWithNewMessage(recent:RecentChat,lastMessage:String)
    {
        var Temprecent = recent
        if Temprecent.senderId != User.currentId{
            Temprecent.unreadCounter += 1
            
        }
        Temprecent.lastmessage = lastMessage
        Temprecent.date = Date()
        
        self.addRecent(recent: Temprecent)
    }
}
