//
//  User.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-02.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseAuth

struct User: Codable,Equatable{
    
    var id = ""
    var username = ""
    var email = ""
    var pushId = ""
    var avatarLink = ""
    var status = ""
    
    static var currentId:String {
        return Auth.auth().currentUser!.uid
    }
    
    
    static var currentUser:User?{
            
        if Auth.auth().currentUser != nil{
            
            if let dict = UserDefaults.standard.data(forKey: kcurrentUser)
            {
                let decoder = JSONDecoder()
                do{
                    let dataUser = try decoder.decode(User.self, from: dict)
                    return dataUser
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        return nil
        
    }
    
    static func ==(lhs:User,rhs:User) -> Bool
    {
        return lhs.id == rhs.id
    }
    
}


func saveUserlocally(user:User)
{
    let jsonencode = JSONEncoder()
    do{
        let datauser = try jsonencode.encode(user)
        UserDefaults.standard.set(datauser, forKey: kcurrentUser)
    }catch{
        print(error.localizedDescription)
    }
}

func createdummyusers(){
    let names  = ["Alice Parker","Joanne cena","Megan Fox","Harry potter","James bond"]
    
    var imageIndex = 1

    for i in 0..<5{
        let id = UUID().uuidString
        let filedir = "Avatars/"+"_\(id)"+".jpg"
        Filestorage.uploadImage(UIImage(named: "profile\(imageIndex)")!, directory: filedir) { documentLink in
            
            let user = User(id: id,username: names[i],email: "user\(i)@mail.com",pushId: "",avatarLink: documentLink ?? "",status: "no status")
            saveusertofirestor(user: user)
            
        }
        imageIndex += 1
        if(imageIndex == 6)
        {
            imageIndex = 1
        }
    }
}
