//
//  FirebaseUserListener.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-02.
//

import Foundation
import FirebaseAuth

class firebaseuserListener{
    static let shared = firebaseuserListener()
    
    private init(){}
    
    func loginwith(email:String,password:String,completion:@escaping(_ error:Error?)->Void)
    {
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            completion(err)
            if err == nil{
                firebaseuserListener.shared.downloadUserFromFirebase(userid: (res?.user.uid)!,email: email)
            }
        }
    }
    
    
    func registerUserWith(email:String,password:String,completion:@escaping(_ error:Error?)->Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            completion(error)
            
            if(error == nil)
            {
                
                if authDataResult?.user != nil{
                    let user = User(id: authDataResult!.user.uid,username: email,email: email,pushId: "",avatarLink: "",status: "hey there")
                    saveUserlocally(user: user)
                    saveusertofirestor(user: user)
                    
                }
                
            }
        }
    }
    
    
    func logout(completion:@escaping(_ err:Error?)->Void){
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kcurrentUser)
            UserDefaults.standard.synchronize()
            completion(nil)
            
        }catch{
            completion(error)
        }
    }
    
    func downloadUserFromFirebase(userid:String,email:String?=nil)
    {
        firebaseRef(.User).document(userid).getDocument { Snap, error in
            guard let doc = Snap else{
                print(error?.localizedDescription)
                return
            }
            let res = Result{
                try? doc.data(as: User.self)
            }
            
            switch res{
            case .success(let userobj):
                if let user = userobj{
                    saveUserlocally(user: user)

                }
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }

    
    
    func downloadAllUserFromFirebase(completion: @escaping(_ allUsers:[User]?)->Void )
    {
        var users:[User] = []
        
        firebaseRef(.User).limit(to: 500).getDocuments { Snapshot, error in
            if error != nil{
                completion(nil)
                print(error?.localizedDescription)
                return
            }
            
            let allUser = Snapshot?.documents.compactMap({ (snapshotquery)->User? in
                return try? snapshotquery.data(as: User.self)
            })
            
            for user in allUser!{
                if user.id != User.currentId
                {
                    users.append(user)
                }
            }
            completion(users)
            
        }
        
    }
    
    
    func downloadUserFromFirebase(withId:[String],completion: @escaping(_ allUsers:[User]?)->Void )
    {
        var count = 0
        var userArray:[User] = []
        for userid in withId{
            firebaseRef(.User).document(userid).getDocument { SnapshotDat, error in
                
                if error != nil{
                    completion(nil)
                    print(error?.localizedDescription)
                    return
                }
                
                let user = try? SnapshotDat?.data(as: User.self)
                userArray.append(user!)
                count+=1
                
                if(count == withId.count)
                {
                    completion(userArray)
                }
                
            }
        }
    }
}


func saveusertofirestor(user:User)
{
    do{
        try firebaseRef(.User).document(user.id).setData(from: user)

    }catch
    {
        print(error.localizedDescription)
    }
}
