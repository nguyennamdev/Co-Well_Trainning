//
//  ChatMessageDelegate.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/6/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

protocol ChatMessageDelegate {
    
    func performZoomInForStartingImageView(image:UIImageView)
    func selectedImageFromPhotoLibrary(image:UIImage)
    
}
