//
//  ContactRequestTableViewCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ContactRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileUserNameLabel: UILabel!
    @IBOutlet weak var contentRequestLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var disacceptButton: UIButton!
    
    var ref:DatabaseReference!
    var delegate:ContactsRequestDelegate?
    
    
    var contactRequest:Contact?{
        didSet{
            guard let contact = self.contactRequest else {
                return
            }
            profileImageView.loadImageUsingCacheWithUrl(urlString: contact.championUrlImage!)
            profileUserNameLabel.text = contact.name
            contentRequestLabel.text =  "\(contact.name!) " + "want to chat with you".localized
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ref = Database.database().reference()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- Actions
    @IBAction func acceptToChat(_ sender: UIButton) {
        if let contact = self.contactRequest{
            acceptButton.isEnabled = false
            delegate?.responseToContactRequest(isAccept: true, with: contact.id)
        }
    }
    
    
    @IBAction func disargeeToChat(_ sender: UIButton) {
        if let contact = self.contactRequest{
            disacceptButton.isEnabled = false
            delegate?.responseToContactRequest(isAccept: false, with: contact.id)
        }
    }
    
}
