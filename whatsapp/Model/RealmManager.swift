//
//  RealmManager.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-15.
//

import Foundation
import RealmSwift

class RealmManager{
    
    static let shared = RealmManager()
    let realm = try! Realm()
    private init(){}
    
    func saveToRealm<T:Object>(obj:T)
    {
        do{
            try realm.write({
                realm.add(obj,update: .all)
//                print(Realm.Configuration.defaultConfiguration.fileURL)
            })
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    
}
