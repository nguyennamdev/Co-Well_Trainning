//
//  Formatter+formatWithUnderDot.swift
//  ThirdDemo
//
//  Created by Nguyen Nam on 5/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

extension Formatter{
    
    static let withUnderDots:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSize = 3
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
    
}

extension Int{
    
    func formatedNumberWithUnderDots() -> String {
        return Formatter.withUnderDots.string(for: self) ?? ""
    }
    
}
