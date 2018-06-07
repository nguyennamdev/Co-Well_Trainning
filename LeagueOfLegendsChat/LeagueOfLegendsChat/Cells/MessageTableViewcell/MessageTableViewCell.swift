//
//  MessageTableViewCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // this property use for NewMessageTableViewController class
    var contact:Contact?{
        didSet{
            profileImageView.loadImageUsingCacheWithUrl(urlString: contact!.championUrlImage!)
            userNameLabel.text = contact?.name
            messageLabel.text = contact?.championName
            messageLabel.textColor = #colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)
            timestampLabel.text = nil
        }
    }
    
    var message:Message?{
        didSet{
            setupNameAndProfileImage()
            if let text = message?.text {
                self.messageLabel.text = text
            }else{
                self.messageLabel.text = "Sent an image".localized
            }
            if let timestamp = message?.timestamp.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timestampLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK:- Private instance methods
    private func setupNameAndProfileImage(){
        let chatParterId:String?
        
        if message?.fromId == Auth.auth().currentUser?.uid{
            chatParterId = message?.toId
        }else{
            chatParterId = message?.fromId
        }
        
        if let id = chatParterId{
            Database.database().reference().child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                if let values = snapshot.value as? [String : Any]{
                    let contact = Contact()
                    contact.setValueForKeys(dict: values)
                    self.userNameLabel.text = contact.name
                    self.profileImageView.loadImageUsingCacheWithUrl(urlString: contact.championUrlImage!)
                }
            })
        }
    }
    
}
