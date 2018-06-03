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
        inputContainerView.backgroundColor = UIColor.red
        // autolayout
        inputContainerView.anchorsLayoutView(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, constants: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 40))
        
        bottomConstaintInputContainerView = NSLayoutConstraint(item: inputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstaintInputContainerView!)
    }
    
    func setupSendButton(){
        inputContainerView.addSubview(sendButton)
        sendButton.anchorsLayoutView(top: inputContainerView.topAnchor, left: nil, bottom: inputContainerView.bottomAnchor, right: inputContainerView.rightAnchor, constants: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 40, height: 0))
    }
    
    func setupInputMessageTextField(){
        inputMessageTextField.delegate = self
        inputContainerView.addSubview(inputMessageTextField)
        inputMessageTextField.anchorsLayoutView(top: inputContainerView.topAnchor, left: inputContainerView.leftAnchor, bottom: inputContainerView.bottomAnchor, right: sendButton.leftAnchor)
    }
    
}
