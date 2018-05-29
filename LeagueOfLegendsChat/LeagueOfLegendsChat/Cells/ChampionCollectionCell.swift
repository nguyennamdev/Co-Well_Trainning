//
//  ChampionCollectionCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class ChampionCollectionCell : UICollectionViewCell {
    
    var champion: Champion?{
        didSet{
            if let urlString = self.champion?.imageUrl{
                // load image
                self.championImageView.loadImageUsingCacheWithUrl(urlString: urlString)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        // setup champion image view
        self.addSubview(championImageView)
        // layout
        championImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        championImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        championImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        championImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // MARK: Views
    let championImageView:UIImageView = {
        let image: UIImageView = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 24
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.green.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
}
