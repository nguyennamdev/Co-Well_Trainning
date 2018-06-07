//
//  StickerCollectionViewCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class StickerCollectionViewCell : UICollectionViewCell {
    
    
    var stickerImage:UIImage?{
        didSet{
            imageView.image = stickerImage!
        }
    }
    
    // MARK:- Views
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews(){
        self.addSubview(imageView)
        imageView.anchorsLayoutView(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
    }

    
}
