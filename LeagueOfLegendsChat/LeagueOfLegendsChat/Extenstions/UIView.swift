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
        if let constants = constants{
            if let topAnchor = top{
                self.topAnchor.constraint(equalTo: topAnchor, constant: constants.top).isActive = true
            }
            if let leftAnchor = left {
                self.leftAnchor.constraint(equalTo: leftAnchor, constant: constants.left).isActive = true
            }
            if let bottomAnchor = bottom{
                self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -constants.bottom).isActive = true
            }
            if let rightAnchor = right{
                self.rightAnchor.constraint(equalTo: rightAnchor, constant: -constants.right).isActive = true
            }
        }
        
        if let size = size{
            if size.width != 0{
                self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            }
            if size.height != 0{
                self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            }
        }
    }
    
}
