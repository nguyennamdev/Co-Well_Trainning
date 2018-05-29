//
//  UITextField+CheckIsEmail.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension UITextField {
    
    func checkTextIsEmail() -> Bool {
        let pattern = "^([^0-9]\\w*)@gmail(\\.com(\\.vn)?)$"
        let predicate = NSPredicate(format: "self MATCHES [c] %@", pattern)
        if !predicate.evaluate(with: self.text){
            return false
        }else{
            return true
        }
    }
    
}
