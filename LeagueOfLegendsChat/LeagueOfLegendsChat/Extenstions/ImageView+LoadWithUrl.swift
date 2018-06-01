//
//  ImageView+LoadWithUrl.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseStorage


let imageCache = NSCache<AnyObject, AnyObject>()


extension UIImageView {
    
    func loadImageUsingCacheWithUrl(urlString:String){
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        Storage.storage().reference(forURL: urlString).getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if error != nil{
                print(error!)
                return
            }
            
            if let downloadImage = UIImage(data: data!){
                // save to imageCache
                imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                self.image = downloadImage
            }
        }
    }
    
}






