//
//  StartChat.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-13.
//

import Foundation
import FirebaseFirestore

func startchat(user1:User,user2:User) -> String
{
    let chatroomid = chatroomIdFrom(user1Id: user1.id, user2Id: user2.id)
    
    
    
    createRecentItems(chatroomid: chatroomid, users: [user1,user2])
    return chatroomid
}

func restartChat(chartRoomId:String,memeberIds:[String])
{
    firebaseuserListener.shared.downloadUserFromFirebase(withId: memeberIds) { allUsers in
        if allUsers!.count > 0{
            createRecentItems(chatroomid: chartRoomId, users: allUsers!)
        }
    }
}
func createRecentItems(chatroomid:String,users:[User])
{
    var membersIdToCreateRecent = [users.first!.id,users.last!.id]
    var getrec = [users.first!,users.last!]
    let index = getrec.firstIndex(of: User.currentUser!)
    getrec.remove(at: index!)
    let recidgen = getrec.first
    firebaseRef(.Recent).whereField(KchatroomID,isEqualTo: chatroomid).getDocuments { snapshot, error in
        
        guard let snapshot = snapshot else{
            return
        }
        if !snapshot.isEmpty{
            membersIdToCreateRecent = removememebr(snapshot: snapshot, memberIds: membersIdToCreateRecent)
        }
      
        for userid in membersIdToCreateRecent{
            
            let senderId = userid == User.currentId ? User.currentUser! : recidgen!
            let receiverId = userid == User.currentId ? recidgen! : User.currentUser!
           
           
            
            let recentobj = RecentChat(id:UUID().uuidString,chatRoomId: chatroomid,senderId: senderId.id,senderName: senderId.username,receiverId: receiverId.id,receriverName: receiverId.username,date: Date(),memeberIds: [senderId.id,receiverId.id],lastmessage: "test",unreadCounter: 0,avatarLink: receiverId.avatarLink)
            
            FirebaseRecentListner.shared.addRecent(recent: recentobj)
            
            

        }
        
        
    }
}
func removememebr(snapshot:QuerySnapshot,memberIds:[String]) -> [String]
{
    var memebridtocreate = memberIds
    
    for recentDara in snapshot.documents{
        let currentRecenet = recentDara.data() as Dictionary
        
        if let currentUserID = currentRecenet["senderId"]{
            if memebridtocreate.contains(currentUserID as! String){
                memebridtocreate.remove(at: memebridtocreate.firstIndex(of: currentUserID as! String)!)
            }
        }
       
    }
    
    return memebridtocreate
}

func chatroomIdFrom(user1Id:String,user2Id:String)->String{
    var chatroomid = ""
    
    let val = user1Id.compare(user2Id).rawValue
    
    chatroomid = val < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    
    return chatroomid
}
