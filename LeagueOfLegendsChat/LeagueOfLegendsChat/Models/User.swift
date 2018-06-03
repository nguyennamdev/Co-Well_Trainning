//
//  User.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User{
    
    var id:String!
    var name:String!
    var email:String!
    var championName:String!
    var championUrlImage:String?
    var contacts:[String]?
    var contactsRequest:[String]?
    var listBlocked:[String]?
    
    init() {
        
    }
    
    func setValueForKeys(values:[String: Any]){
        self.name = values[Define.NAME_STRING] as! String
        self.email = values[Define.EMAIL_STRING] as! String
        self.championName = values[Define.CHAMPION_NAME] as! String
        self.championUrlImage = values[Define.CHAMPION_URL_IMAGE] as? String
    }
    
    func setContactsRequest(snapshot:DataSnapshot){
       let snapshotChildrens = snapshot.childSnapshot(forPath: Define.CONTACT_REQUEST).children.allObjects as? [DataSnapshot]
        if let childrens = snapshotChildrens{
            self.contactsRequest = [String]()
            for child in childrens{
                self.contactsRequest?.append(child.value as! String)
            }
        }
    }
    
    func setContacts(snapshot:DataSnapshot){
        let snapshotChildrens = snapshot.childSnapshot(forPath: Define.CONTACTS).children.allObjects as? [DataSnapshot]
        if let chilrens = snapshotChildrens{
            self.contacts = [String]()
            for child in chilrens{
                self.contacts?.append(child.value as! String)
            }
        }
    }
    
    func setListBlocked(snapshot:DataSnapshot){
        let snapshotChildrens = snapshot.childSnapshot(forPath: Define.CONTACTS_BLOCKED).children.allObjects as? [DataSnapshot]
        if let childrens = snapshotChildrens{
            self.listBlocked = [String]()
            for child in childrens{
                self.listBlocked?.append(child.value as! String)
            }
        }
    }
    
}
