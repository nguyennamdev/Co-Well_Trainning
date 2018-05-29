//
//  Animal.swift
//  FirstDemo
//
//  Created by Nguyen Nam on 5/9/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import UIKit

class Animal: NSObject {
    
    var name:String?
    var legs:Int?
    var color:UIColor?
    
    init(name: String, legs: Int, color: UIColor) {
        super.init()
        self.name = name
        self.legs = legs
        self.color = color
    }
    
    public func say(){
        
    }
    
}
