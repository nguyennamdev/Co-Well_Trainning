//
//  UserDefaults+UserLoggin.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case isShowedIntroduct
    }
    
    func setIsLoggedIn(value: Bool){
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func getIsLoggedIn() -> Bool{
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func setIsShowedIntroduct(value:Bool){
        set(value, forKey: UserDefaultsKeys.isShowedIntroduct.rawValue)
    }
    
    func getIsShowedIntroduct() -> Bool{
        return bool(forKey: UserDefaultsKeys.isShowedIntroduct.rawValue)
    }
    
}
