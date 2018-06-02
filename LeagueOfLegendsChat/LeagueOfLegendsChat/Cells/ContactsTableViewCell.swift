//
//  ContactsTableViewCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/31/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileUserImageView: UIImageView!
    @IBOutlet weak var profileUserEmail: UILabel!
    @IBOutlet weak var profileUserNameLabel: UILabel!
    
    var contact:Contact?{
        didSet{
            guard let contact = self.contact else {
                return
            }
            profileUserImageView.loadImageUsingCacheWithUrl(urlString: contact.championUrlImage!)
            profileUserNameLabel.text = contact.name
            profileUserEmail.text = contact.email
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
