//
//  BaseCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/30/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class BaseCell : UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
    }
    
}
