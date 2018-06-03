//
//  Contact.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Contact{
    
    var id:String!
    var name:String!
    var email:String!
    var championName:String!
    var championUrlImage:String?
    
    init() {
        
    }
    
    func setValueForKeys(dict:[String: Any]){
        self.name = dict[Define.NAME_STRING] as! String
        self.email = dict[Define.EMAIL_STRING] as! String
        self.championName = dict[Define.CHAMPION_NAME] as! String
        self.championUrlImage = dict[Define.CHAMPION_URL_IMAGE] as? String
    }
    
    
    
}
