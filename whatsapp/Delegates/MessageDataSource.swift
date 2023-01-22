//
//  MessageDataSource.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-14.
//

import Foundation
import MessageKit
extension MessageViewController:MessagesDataSource{
    public func currentSender() -> MessageKit.SenderType {
        return currentUser
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return mkMessages[indexPath.section]
    }
    
    public func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return mkMessages.count

    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0{
            let showLoadMore = (indexPath.section == 0) && (allLocalMessages.count > displayMessagesCount) 
            let text = showLoadMore ? "Pull to Load More": MessageKitDateFormatter.shared.string(from: message.sentDate)
            let font  = showLoadMore ? UIFont.systemFont(ofSize: 13):UIFont.systemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.systemGray
            return NSAttributedString(string: text,attributes: [.font:font,.foregroundColor:color])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message){
            let message2 = mkMessages[indexPath.section]
            let status = indexPath.section == mkMessages.count - 1 ? message2.status + " " + message2.readDate.time() : ""
            return NSAttributedString(string: status,attributes: [.font: UIFont.boldSystemFont(ofSize: 10),.foregroundColor:UIColor.darkGray])
        }
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section != mkMessages.count - 1{
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: message.sentDate.time(),attributes: [.font:font,.foregroundColor:color])
        }
        return nil
    }
    
}
