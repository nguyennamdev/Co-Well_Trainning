//
//  User.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

class User{
    
    var id:String!
    var name:String!
    var email:String!
    var championName:String!
    var championUrlImage:String?
    
    init() {
        
    }
    
    func setValueForKeys(values:[String: Any]){
        self.name = values[Define.USER_NAME] as! String
        self.email = values[Define.USER_EMAIL] as! String
        self.championName = values[Define.USER_CHAMPION_NAME] as! String
        self.championUrlImage = values[Define.USER_CHAMPION_URL_IMAGE] as? String
    }
    
}
