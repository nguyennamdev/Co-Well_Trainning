//
//  Table.swift
//  SecondDemo
//
//  Created by Nguyen Nam on 5/11/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import UIKit

class Table {
    
    var number:Int
    var color:UIColor
    var tableType:TableType
    var tableLegs:Int
    var seat:Seat?
    
    init(_ number:Int, _ color: UIColor,_ tableType:TableType,_ tableLegs:Int, _ seat:Seat? = nil) {
        self.number = number
        self.color = color
        self.tableType = tableType
        self.tableLegs = tableLegs
        self.seat = seat
    }
    
    func switchSeat(newSeat:Seat?,to table:Table){
        let holdOldSeat = self.seat
        self.seat = newSeat
        table.seat = holdOldSeat
    }
}
