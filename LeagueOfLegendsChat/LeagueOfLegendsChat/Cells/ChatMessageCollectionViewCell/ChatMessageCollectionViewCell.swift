//
//  ChatMessageCollectionViewCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatMessageCollectionViewCell : UICollectionViewCell{
    
    // MARK:- Properties
    var chatMessageDelegate:ChatMessageDelegate?
    
    // MARK:- Views
    let bubbleView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let contentTextView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        textView.textAlignment = .center
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.gray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var messageImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomMessageImage(tap:))))
        imageView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        return imageView
    }()
    
    let activityIndicator:UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.tintColor = UIColor.blue
        ac.hidesWhenStopped = true
        return ac
    }()
    
    
    // MARK:- Properties
    var bubbleLeftLayoutConstaint:NSLayoutConstraint?
    var bubbleRightLayoutConstaint:NSLayoutConstraint?
    var bubbleWidthLayoutConstaint:NSLayoutConstraint?
    
    var contact:Contact?{
        didSet{
            guard let imageUrl = contact?.championUrlImage else { return }
            profileImageView.loadImageUsingCacheWithUrl(urlString: imageUrl)
        }
    }
    
    var message:Message?{
        didSet{
            // solve width of bubble view
            var bubbleWidth:CGFloat = 200
            if let text = self.message!.text{
                // get estimate width of text
                let frameText = text.estimateFrameOfString()
                bubbleWidth = frameText.width + 32
                self.bubbleWidthLayoutConstaint?.constant = bubbleWidth
    
                // assign text to contentTextView
                contentTextView.text = message!.text
                messageImageView.isHidden = true
            }else{
                self.bubbleWidthLayoutConstaint?.constant = 250
                self.contentTextView.isHidden = true
            }
            configurationCell(message: message!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private instance methods
    private func configurationCell(message:Message){
        // message send by current user
        if message.fromId == Auth.auth().currentUser!.uid{
            // outgoing bubble
            self.bubbleView.backgroundColor = UIColor.blue
            self.bubbleRightLayoutConstaint?.isActive = true
            self.bubbleLeftLayoutConstaint?.isActive = false
            self.profileImageView.isHidden = true
            self.contentTextView.textColor = UIColor.white
        }else{
            // incomming bubble
            self.bubbleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.bubbleRightLayoutConstaint?.isActive = false
            self.bubbleLeftLayoutConstaint?.isActive = true
            self.profileImageView.isHidden = false
            self.contentTextView.textColor = UIColor.black
        }
        
        if let imageUrl = message.imageUrl {
            self.messageImageView.isHidden = false
            self.messageImageView.loadImageUsingCacheWithUrl(urlString: imageUrl)
            self.bubbleView.backgroundColor = UIColor.clear
        }else{
            self.messageImageView.image = nil
        }
    }
    
    func setupViews(){
        setupProfileImageView()
        setupBubbleView()
        setupContentTextView()
        setupMessageImageView()
        setupActivityIndicator()
    }
    
    // MARK: Actions
    @objc func handleZoomMessageImage(tap:UITapGestureRecognizer){
        // cast down view click to image view
        if let image = tap.view as? UIImageView{
            chatMessageDelegate?.performZoomInForStatingImageView(image: image)
        }
    }
}
