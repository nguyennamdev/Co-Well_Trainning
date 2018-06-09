//
//  ChatMessageCollectionViewCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/9/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatMessageCollectionViewCell: UICollectionViewCell {
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Views
    let bubbleView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    let messageTextView:UITextView = {
        let tv = UITextView()
        tv.textAlignment = .center
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var messageImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomMessageImage(sender:))))
        return imageView
    }()
    
    // MARK:- Properties
    var bubbleLeftConstaint:NSLayoutConstraint?
    var bubbleRightConstaint:NSLayoutConstraint?
    var bubbleWidthConstaint:NSLayoutConstraint?
    
    var chatMessageDelegate:ChatMessageDelegate?
    
    var message:Message?{
        didSet{
            setupCell(message: message!)
            setupContentMessage(message: message!)
        }
    }
    
    var contact:Contact?{
        didSet{
            if let imageUrl = contact?.championUrlImage{
                self.profileImageView.loadImageUsingCacheWithUrl(urlString: imageUrl)
            }
        }
    }
    
    // MARK:- Private instance methods
    private func setupCell(message:Message){
        // default x constaint of bubble view
        self.bubbleLeftConstaint?.isActive = false
        self.bubbleRightConstaint?.isActive = true
        // handle x constaint of bubble view
        if message.fromId == Auth.auth().currentUser?.uid{
            // message sent by current user
            self.bubbleRightConstaint?.isActive = true
            self.bubbleLeftConstaint?.isActive = false
            self.messageTextView.textColor = UIColor.white
            self.profileImageView.isHidden = true
        }else{
            // message sent by contact is chating
            self.bubbleView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            self.bubbleRightConstaint?.isActive = false
            self.bubbleLeftConstaint?.isActive = true
            self.messageTextView.textColor = UIColor.black
            self.profileImageView.isHidden = false
        }
    }
    
    private func setupContentMessage(message:Message){
        // handle content message
        if let text = message.text{
            displayMessageText(text: text)
        }
        // content without text, it can stickers or images message
        if let imageUrl = message.imageUrl{
            displayMessageImage(imageUrl: imageUrl)
        }else if let stickerUrl = message.stickerUrl{
            displayMessageSticker(stickerUrl: stickerUrl)
        }else{
            self.messageImageView.image = nil
        }
    }
    
    private func displayMessageText(text:String){
        messageTextView.text = text
        // handle width bubble
        let bubbleWidth = text.estimateFrameOfString().width + 32
        bubbleWidthConstaint?.constant = bubbleWidth
        messageTextView.isHidden = false
        messageImageView.isHidden = true
    }
    
    private func displayMessageImage(imageUrl:String){
        messageImageView.isHidden = false
        messageTextView.isHidden = true
        messageImageView.loadImageUsingCacheWithUrl(urlString: imageUrl)
        bubbleWidthConstaint?.constant = 250
        self.bubbleView.backgroundColor = UIColor.clear
        // image view can zoom
        messageImageView.isUserInteractionEnabled = true
    }
    
    private func displayMessageSticker(stickerUrl:String){
        messageTextView.isHidden = true
        messageImageView.isHidden = false
        messageImageView.loadImageUsingCacheWithUrl(urlString: stickerUrl)
        bubbleWidthConstaint?.constant = 150
        self.bubbleView.backgroundColor = UIColor.clear
        // sticker can't zoom
        messageImageView.isUserInteractionEnabled = false
    }
    
    // MARK:- Setup views
    private func setupViews(){
        setupProfileImageView()
        setupBubbleView()
        setupMessageTextView()
        setupMessageImageView()
    }
    
    private func setupProfileImageView(){
        self.addSubview(profileImageView)
        profileImageView.anchorsLayoutView(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, constants: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 32, height: 32))
    }
    
    private func setupBubbleView(){
        self.addSubview(bubbleView)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        // x constaint
        bubbleLeftConstaint = NSLayoutConstraint(item: bubbleView, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 12)
        bubbleLeftConstaint?.isActive = false
        bubbleRightConstaint = NSLayoutConstraint(item: bubbleView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -12)
        bubbleRightConstaint?.isActive = true
        // width constaint
        bubbleWidthConstaint = NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        self.addConstraints([bubbleLeftConstaint!, bubbleRightConstaint!, bubbleWidthConstaint!])
        
        // y, height constaints
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    private func setupMessageTextView(){
        bubbleView.addSubview(messageTextView)
        messageTextView.anchorsLayoutView(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor)
    }
    
    private func setupMessageImageView(){
        bubbleView.addSubview(messageImageView)
        messageImageView.anchorsLayoutView(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor)
    }
    
    // MARK:- Actions
    @objc private func handleZoomMessageImage(sender:UITapGestureRecognizer){
        // get imageview tapped
        let imageView = sender.view as! UIImageView
        chatMessageDelegate?.performZoomInForStartingImageView(image: imageView)
    }
    
}










