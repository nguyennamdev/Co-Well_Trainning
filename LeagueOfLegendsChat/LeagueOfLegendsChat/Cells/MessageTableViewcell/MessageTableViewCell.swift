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
            if let text = message?.text {
                self.messageLabel.text = text
            }else if message?.imageUrl != nil{
                self.messageLabel.text = "Sent an image".localized
            }else if message?.stickerUrl != nil{
                self.messageLabel.text = "Sent a sticker".localized
            }else if message?.audioUrl != nil{
                self.messageLabel.text = "Sent an audio".localized
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
        
        userNameLabel.text = nil
        profileImageView.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
