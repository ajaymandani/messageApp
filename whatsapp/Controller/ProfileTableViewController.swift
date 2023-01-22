//
//  ProfileTableViewController.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-10.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    var user:User? = nil
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var useravatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user{
            username.text = user.username
            if user.avatarLink != ""{
                Filestorage.downloadImageUrl(imageurl: user.avatarLink) { img in
                    DispatchQueue.main.async {
                        self.useravatar.image = img
                    }
                    
                }
            }else{
                useravatar.image = UIImage(named: "avatar")
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if(indexPath.section == 1)
        {
            let chatroomid = startchat(user1: User.currentUser!, user2: user!)
           
            let privatechat = MessageViewController(chatId: chatroomid,recepientId: user!.id,recepientName: user!.username)
            navigationController?.pushViewController(privatechat, animated: true)
            
        }
    }
  
}
