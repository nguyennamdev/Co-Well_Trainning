//
//  MoneyType.swift
//  ThirdDemo
//
//  Created by Nguyen Nam on 5/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

enum MoneyType : String{
    
    case USD = "usd 🇺🇸"
    case VND = "vnđ 🇻🇳"
    case YEN = "yen 🇯🇵"
    
    static let allValues = [MoneyType.USD, MoneyType.VND, MoneyType.YEN]
    
}


