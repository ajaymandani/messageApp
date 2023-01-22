//
//  LocalMessage.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-14.
//

import Foundation
import RealmSwift

class LocalMessage:Object,Codable{
    @objc dynamic var id = ""
    @objc dynamic var chatRoomId = ""
    @objc dynamic var date = Date()
    @objc dynamic var senderName = ""
    @objc dynamic var senderId = ""
    @objc dynamic var senderInitials = ""
    @objc dynamic var readDate = Date()
    @objc dynamic var type = ""
    @objc dynamic var status = ""
    @objc dynamic var message = ""
    @objc dynamic var audioUrl = ""
    @objc dynamic var videoUrl = ""
    @objc dynamic var pictureUrl = ""
    @objc dynamic var latitiude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var audioDuration = 0.0

    override class func primaryKey() -> String? {
        return "id"
    }
    
}
