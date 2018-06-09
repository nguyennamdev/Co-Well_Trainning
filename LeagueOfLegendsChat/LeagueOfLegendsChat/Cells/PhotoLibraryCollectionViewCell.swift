//
//  PhotoLibraryCollectionViewCell.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/6/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class PhotoLibraryCollectionViewCell : UICollectionViewCell {
    
    var isShowingSendButton:Bool = false
    var startingImage:UIImage!
    var chatMessageDelegate:ChatMessageDelegate?

    var image:UIImage?{
        didSet{
            startingImage = image!
            imageView.image = image!
        }
    }
    
    lazy var imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showSendButton(sender:))))
        return imageView
    }()
    
    lazy var sendButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.layer.cornerRadius = 30
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.5
        button.setTitle("Send".localized, for: .normal)
        button.backgroundColor = UIColor.gray
        button.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupSendButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        sendButton.isHidden = true
    }
    
    // MARK:- Layout views
    private func setupImageView(){
        self.addSubview(imageView)
        imageView.anchorsLayoutView(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
    }
    
    private func setupSendButton(){
        imageView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.isHidden = true
    }
    
    // MARK:- Actions
    @objc private func showSendButton(sender:UITapGestureRecognizer){
        isShowingSendButton = !isShowingSendButton
        let imageSelected = sender.view as! UIImageView
        if isShowingSendButton{
            // blur image view
            imageSelected.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.7729462232)
            imageSelected.image = nil
            sendButton.isHidden = false
        }else{
            // assign again startImage to imageview
            imageSelected.backgroundColor = UIColor.clear
            imageSelected.image = startingImage
            sendButton.isHidden = true
        }
    }
    
    @objc private func handleSelectImage(){
        if let image = self.image{
            chatMessageDelegate?.selectedImageFromPhotoLibrary(image: image)
            imageView.image = image
            imageView.backgroundColor = UIColor.clear
            sendButton.isHidden = true
        }
    }
    
   
    
}
