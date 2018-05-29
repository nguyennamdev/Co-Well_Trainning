//
//  Champion.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

class Champion {
    
    var imageUrl:String?
    var name: String?
    
    init() {
    }
    
    init(imageUrl: String, name: String) {
        self.imageUrl = imageUrl
        self.name = name
    }
    
    func setValueWithDictionary(dict: NSDictionary){
        self.imageUrl = dict.value(forKey: Define.CHAMPION_IMAGE_URL) as? String
        self.name = dict.value(forKey: Define.CHAMPION_NAME) as? String
    }
    
}
