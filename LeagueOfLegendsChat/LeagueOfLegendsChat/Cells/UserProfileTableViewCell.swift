//
//  UserProfileTableViewCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/30/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class UserProfileTableViewCell : BaseCell{
    
    // MARK:- outlets
    let bubbleView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    let bubbleImageView:UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
    let contentLabel:UILabel = {
        let label = UILabel()
        //113,84,49
        label.textColor = UIColor(red: 113/255, green: 84/255, blue: 49/255, alpha: 1)
        return label
    }()
    
    var userInfo:UserInfo?{
        didSet{
            guard let userInfo = self.userInfo else {
                return
            }
            bubbleView.backgroundColor = userInfo.bubbleColor
            bubbleImageView.image = userInfo.icon
            titleLabel.text = userInfo.title
            contentLabel.text = userInfo.content
        }
    }

    
    override func setupViews() {
        self.backgroundColor = UIColor.clear
//        self.selectionStyle = .none
        setupBubbleView()
        setupBubbleImageView()
        setupTitleLabel()
        setupContentLabel()
    }
    
    // MARK:- Layout views
    private func setupBubbleView(){
        self.addSubview(bubbleView)
        bubbleView.anchorsLayoutView(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, constants: UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 0))
        bubbleView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1, constant: -16).isActive = true
    }
    
    private func setupBubbleImageView(){
        bubbleView.addSubview(bubbleImageView)
        bubbleImageView.anchorsLayoutView(top: bubbleView.topAnchor, left: bubbleView.leftAnchor, bottom: bubbleView.bottomAnchor, right: bubbleView.rightAnchor, constants: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
    }
    
    private func setupTitleLabel(){
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 8).isActive = true
    }
    
    private func setupContentLabel(){
        self.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 8).isActive = true
        contentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -26).isActive = true
    }
    
}
