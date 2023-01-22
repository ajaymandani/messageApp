//
//  RecentChat.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-10.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentChat:Codable{
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receriverName = ""
    @ServerTimestamp var date = Date()
    var memeberIds = [""]
    var lastmessage = ""
    var unreadCounter = 0
    var avatarLink = ""
}
