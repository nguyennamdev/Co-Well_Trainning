//
//  Phone.swift
//  ThirdDemo
//
//  Created by Nguyen Nam on 5/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import UIKit

class Phone {
    
    var name:String
    var price:Int
    var image:UIImage?
    
    
    init(_ name:String, _ price: Int, _ image:UIImage? = nil) {
        self.name = name
        self.price = price
        self.image = image
    }
    
    init() {
        self.name = ""
        self.price = 0
        self.image = nil
    }
    
}
