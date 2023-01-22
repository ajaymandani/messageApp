//
//  EditProfileTableViewController.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-04.
//

import UIKit
import Gallery
class EditProfileTableViewController: UITableViewController {
   
    @IBOutlet weak var avatarimage: UIImageView!
    
    @IBOutlet weak var usernametextfield: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    var gallery:GalleryController!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernametextfield.delegate = self
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiupdate()
    }
    @IBAction func editprofileBtn(_ sender: UIButton) {
        showgalleryedit()
        
    }
    
    func showgalleryedit(){
    
        gallery = GalleryController()
        gallery.delegate = self
        Config.tabsToShow = [.cameraTab,.imageTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        gallery.modalPresentationStyle = .fullScreen
        self.present(gallery, animated: true)
    }
    
    
    func uiupdate(){
        if let user = User.currentUser{
            usernametextfield.text = user.username
            statusLabel.text = user.status
                
            if user.avatarLink != "" {
                
            }

        }
    }
    
    func uploadAvatarImage(image:UIImage)
    {
        DispatchQueue.main.async {
            self.avatarimage.image = image

        }
        
        let fileDirec = "Avatars/"+"_\(User.currentId)"+".jpeg"
        Filestorage.uploadImage(image, directory: fileDirec) { documentLink in
            if var user = User.currentUser{
                user.avatarLink = documentLink ?? ""
                saveUserlocally(user: user)
                saveusertofirestor(user: user)
                
            }
            Filestorage.savefilelocally(filedata: image.jpegData(compressionQuality: 1)! as NSData, filename: User.currentId)
            
        }
        
    }
    
    
    
}

extension EditProfileTableViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernametextfield{
            if textField.text != ""{
                if var curruser = User.currentUser{
                    curruser.username = textField.text!
                    saveUserlocally(user: curruser)
                    saveusertofirestor(user: curruser)
                    
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
    }
}

extension EditProfileTableViewController: GalleryControllerDelegate{
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        
        if images.count>0{
           let img = images.first!
            img.resolve { myimage in
                
                if let myimage = myimage{
                    self.uploadAvatarImage(image: myimage)
                   
                }
                
            }
        }
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true)
    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true)
    }
    
    
}
