//
//  Int+Currency.swift
//  ThirdDemo
//
//  Created by Nguyen Nam on 5/18/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

extension Int{
    
    var USD:Int{
        return self * 1
    }
    
    var VND:Int{
        return self * 22000
    }
    
    var YEN:Int {
        return self * 109
    }
    
}
