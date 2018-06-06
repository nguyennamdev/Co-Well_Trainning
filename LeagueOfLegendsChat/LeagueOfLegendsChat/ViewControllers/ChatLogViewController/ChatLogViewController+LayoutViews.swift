//
//  ChatLogViewController+LayoutViews.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension ChatLogViewController {
    
    func setupInputViewController(){
        view.addSubview(inputContainerView)
        inputContainerView.backgroundColor = UIColor.white
        // autolayout
        inputContainerView.anchorsLayoutView(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, constants: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 35))
        
        bottomConstaintInputContainerView = NSLayoutConstraint(item: inputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstaintInputContainerView!)
    }
    
    func setupSendButton(){
        inputContainerView.addSubview(sendButton)
        sendButton.anchorsLayoutView(top: inputContainerView.topAnchor, left: nil, bottom: inputContainerView.bottomAnchor, right: inputContainerView.rightAnchor, constants: UIEdgeInsets(top: 1.5, left: 0, bottom: 1.5, right: 0), size: CGSize(width: 32, height: 0))
    }
  
    func setupMediaActionsStackView(){
        inputContainerView.addSubview(mediaActionsView)
        mediaActionsView.translatesAutoresizingMaskIntoConstraints = false
        mediaActionsView.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor).isActive = true
        mediaActionsView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
        mediaActionsView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        widthConstaintMediaActionsView = NSLayoutConstraint(item: mediaActionsView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 56)
        inputContainerView.addConstraint(widthConstaintMediaActionsView!)
        
        // setup subviews
        // clear any existing buttons
        for button in mediaButtons{
            mediaActionsView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        // add button to stack
        for button in mediaButtons{
            mediaActionsView.addArrangedSubview(button)
        }
        
    }
    
    func setupInputMessageTextField(){
        inputMessageTextField.placeholder = " Aa"
        inputMessageTextField.layer.borderWidth = 0.5
        inputMessageTextField.layer.borderColor = UIColor.gray.cgColor
        inputMessageTextField.layer.cornerRadius = 17.5
        inputMessageTextField.delegate = self
        inputContainerView.addSubview(inputMessageTextField)
        inputMessageTextField.anchorsLayoutView(top: inputContainerView.topAnchor, left: mediaActionsView.rightAnchor, bottom: inputContainerView.bottomAnchor, right: sendButton.leftAnchor, constants: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0))
    }
    
    func setupPhotoLibraryCollection(){
        self.view.addSubview(photosLibraryCollectionView)
        photosLibraryCollectionView.anchorsLayoutView(top: nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
        
        heightConstaintPhotoLibraryCollectionView = NSLayoutConstraint(item: photosLibraryCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.view.addConstraint(heightConstaintPhotoLibraryCollectionView!)
    }
    
    func setupStickersCollectionView(){
        self.view.addSubview(stickersCollectionView)
        stickersCollectionView.anchorsLayoutView(top: nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
        
        heightConstaintStickerCollectionView = NSLayoutConstraint(item: stickersCollectionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        self.view.addConstraint(heightConstaintStickerCollectionView!)
    }
    
    // MARK:- Block container views
    
    func setupBlockContainerView(){
        view.addSubview(blockContainerView)
        blockContainerView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        // autolayout
        blockContainerView.anchorsLayoutView(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, constants: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 35))
    }
    
    func setupUnblockButton(){
        blockContainerView.addSubview(unblockButton)
        // autolayout
        unblockButton.anchorsLayoutView(top: blockContainerView.topAnchor, left: nil, bottom: blockContainerView.bottomAnchor, right: blockContainerView.rightAnchor, constants: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12), size: CGSize(width: 100, height: 0))
    }
    
    func setupBlockTitleLabel(){
        blockContainerView.addSubview(blockTitleLabel)
        // autolayout
        blockTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        blockTitleLabel.centerYAnchor.constraint(equalTo: blockContainerView.centerYAnchor).isActive = true
        blockTitleLabel.leftAnchor.constraint(equalTo: blockContainerView.leftAnchor, constant: 12).isActive = true
        blockTitleLabel.rightAnchor.constraint(equalTo: unblockButton.leftAnchor, constant: -8).isActive = true
    }
    
    
}
