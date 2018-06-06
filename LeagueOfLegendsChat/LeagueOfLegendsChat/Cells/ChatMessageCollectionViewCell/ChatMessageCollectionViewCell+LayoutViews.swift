//
//  ChatMessageCollectionViewCell+LayoutViews.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension ChatMessageCollectionViewCell {
    
    func setupBubbleView(){
        self.addSubview(bubbleView)
        // x
        bubbleLeftLayoutConstaint = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleLeftLayoutConstaint?.isActive = false

        bubbleRightLayoutConstaint = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        bubbleRightLayoutConstaint?.isActive = true
    
        // w
        bubbleWidthLayoutConstaint = NSLayoutConstraint(item: bubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        self.addConstraint(bubbleWidthLayoutConstaint!)
        // y,h
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupContentTextView(){
        bubbleView.addSubview(contentTextView)
        contentTextView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        contentTextView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        contentTextView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        contentTextView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
    }
    
    func setupProfileImageView(){
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.image = #imageLiteral(resourceName: "chat")
    }
    
    func setupMessageImageView(){
        bubbleView.addSubview(messageImageView)
        messageImageView.anchorsLayoutView(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor)
    }
    
    func setupActivityIndicator(){
        messageImageView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: messageImageView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: messageImageView.centerYAnchor).isActive = true
    }
    
}
