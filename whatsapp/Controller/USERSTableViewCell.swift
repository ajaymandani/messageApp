//
//  USERSTableViewCell.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-08.
//

import UIKit

class USERSTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    func configureUser(user:User){
        usernameLabel.text = user.username
        statusLabel.text = user.status
    
        if user.avatarLink != ""{
            Filestorage.downloadImageUrl(imageurl: user.avatarLink) { img in
                DispatchQueue.main.async {
                    self.avatarimg.image = img
                }
                
            }
        }else{
            self.avatarimg.image = UIImage(named: "avatar")
        }
    }

}
