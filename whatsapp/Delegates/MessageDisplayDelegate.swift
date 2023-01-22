//
//  MessageDisplayDelegate.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-14.
//

import Foundation
import MessageKit
extension MessageViewController:MessagesDisplayDelegate{
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .label
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? MessageDefaults.bubblecolorOutgoing : MessageDefaults.bubblecolorIncoming
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail:MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight:.bottomLeft
        return .bubbleTail(tail, .curved)
    }
}
