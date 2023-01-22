//
//  InputBarAccessoryDelegate.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-14.
//

import Foundation
import InputBarAccessoryView
import MessageKit
extension MessageViewController:InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if text != ""{
           typingIndecatorUpdate()

        }
        updateMicButtonStatus(show:text == "")
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components{
            if let text = component as? String{
                messageSend(text: text, photo: nil, video: nil, audio: nil, location: nil)
            }
        }
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
    
    
}
