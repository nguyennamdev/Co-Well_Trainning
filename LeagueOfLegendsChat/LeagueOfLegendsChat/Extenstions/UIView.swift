//
//  UIView.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/29/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchorsLayoutView(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, constants: UIEdgeInsets? = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize? = CGSize(width: 0, height: 0)){
        self.translatesAutoresizingMaskIntoConstraints = false
        if top != nil{
            topAnchor.constraint(equalTo: top!, constant: constants!.top).isActive = true
        }
        if left != nil {
            leftAnchor.constraint(equalTo: left!, constant: constants!.left).isActive = true
        }
        if bottom != nil{
            bottomAnchor.constraint(equalTo: bottom!, constant: -constants!.bottom).isActive = true
        }
        if right != nil{
            rightAnchor.constraint(equalTo: right!, constant: -constants!.right).isActive = true
        }
        
        if let size = size{
            if size.width != 0{
                widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
            if size.height != 0{
                heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }
        }
    }
    
}
