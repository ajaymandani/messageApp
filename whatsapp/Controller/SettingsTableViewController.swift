//
//  SettingsTableViewController.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-02.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var profileImage: NSLayoutConstraint!
    @IBOutlet weak var avatarimg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()


        
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let k = UIView()
        return k
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0{
            self.performSegue(withIdentifier: "showedit", sender: self)
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0
        {
            tableView.sectionHeaderTopPadding = 2.0
        }
       
        return 0
    }
    override func viewDidAppear(_ animated: Bool) {
        uiupdate()
    }
    
    func uiupdate(){
        if let user = User.currentUser{
            namelabel.text = user.username
            statusLabel.text = user.status
                
            if user.avatarLink != "" {
                Filestorage.downloadImageUrl(imageurl: user.avatarLink) { img in
                    DispatchQueue.main.async {
                        self.avatarimg.image = img
                    }
                    
                }
            }

        }
    }
    
    @IBAction func logoutbtn(_ sender: UIButton) {
        firebaseuserListener.shared.logout { err in
            if err == nil{
                let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView") 
                DispatchQueue.main.async {
                    story.modalPresentationStyle = .fullScreen
                    self.present(story, animated: true)
                }
                
            }else{
                print(err?.localizedDescription)
            }
        }
    }
    

}
