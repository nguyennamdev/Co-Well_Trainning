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
    
    func showToast(toastMessage:String, duration:CGFloat, topAnchor:NSLayoutYAxisAnchor?, leftAnchor:NSLayoutXAxisAnchor?, bottomAnchor:NSLayoutYAxisAnchor?, rightAnchor:NSLayoutXAxisAnchor?){
        // view to shadow bg and stopping user interaction
        let toastView = UIView()
        self.addSubview(toastView)
        // caculating toast view frame
        let width = toastMessage.estimateFrameOfString().width + 100
        let height = toastMessage.estimateFrameOfString().height
        // layout for toast view
        toastView.anchorsLayoutView(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, constants: UIEdgeInsets.zero, size: CGSize(width: width, height: height))
        
        toastView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true
        
        // label for showing toast message
        let label = UILabel()
        toastView.addSubview(label)
        // layout for label
        label.anchorsLayoutView(top: toastView.topAnchor, left: toastView.leftAnchor, bottom: toastView.bottomAnchor, right: toastView.rightAnchor)
        
        label.text = toastMessage
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        // animate toast view
        UIView.animateKeyframes(withDuration: TimeInterval(duration), delay: 0.1, options: [], animations: {
            toastView.alpha = 0
        }, completion: { (completed) in
            // remove toast view
            toastView.removeFromSuperview()
        })
        
    }
    
}
