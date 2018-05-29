//
//  PhoneTableViewCell.swift
//  ThirdDemo
//
//  Created by Nguyen Nam on 5/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class PhoneTableViewCell: UITableViewCell {
    
    // MARK: Views
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var phoneNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: Properties
    var phone:Phone? {
        didSet{
            guard let phone = self.phone else {
                return
            }
            
            // set value for views
            phone.image == nil ? (phoneImage.image = #imageLiteral(resourceName: "smartphone")): (phoneImage.image = phone.image)
            phoneNameLabel.text = phone.name
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
