//
//  RecentTableViewCell.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-11.
//

import UIKit

class RecentTableViewCell: UITableViewCell {

    @IBOutlet weak var unreadLabel: UILabel!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var messagelabel: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatarimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(recent:RecentChat){
        username.text = recent.receriverName
        messagelabel.text = recent.lastmessage
        
        if recent.unreadCounter > 0 {
            self.unreadLabel.text = "\(recent.unreadCounter)"
            self.counterView.isHidden = false
        }else{
            self.counterView.isHidden = true
        }
        
        avatarlinkset(avatarlink:recent.avatarLink)
        
        datelabel.text = "\(timeelapsed(recent.date ?? Date()))"
    }
    
    func avatarlinkset(avatarlink:String)
    {
        if avatarlink != ""{
            Filestorage.downloadImageUrl(imageurl: avatarlink) { img in
                DispatchQueue.main.async {
                    self.avatarimg.image = img
                }
               
            }
        }else{
            avatarimg.image = UIImage(named: "avatar")
        }
    }

}
