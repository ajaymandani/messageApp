//
//  FCollectionRefrence.swift
//  whatsapp
//
//  Created by Ajay Mandani on 2023-01-02.
//

import Foundation
import FirebaseFirestore

enum fcollectionref:String{
    case User
    case Recent
    case Messages
    case Typing
}
func firebaseRef(_ collectionref:fcollectionref)->CollectionReference{
    return Firestore.firestore().collection(collectionref.rawValue)
}
