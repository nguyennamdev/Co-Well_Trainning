//
//  ChatLogViewController+CollectionView.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/6/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

// MARK:- UICollectionViewDataSource
extension ChatLogViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return images.count
        }else{
            return self.messages.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1{
            // photoLibraryCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoLibraryCollectionViewCell
            cell?.chatMessageDelegate = self
            cell?.image = self.images[indexPath.row]
            return cell!
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? ChatMessageCollectionViewCell
            cell?.message = self.messages[indexPath.row]
            cell?.contact = self.contact
            cell?.chatMessageDelegate = self
            return cell!
        }
    }
    
}
// MARK:- UICollectionViewDelegateFlowLayout
extension ChatLogViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize = CGSize()
        if collectionView.tag != 1{
            var height:CGFloat = 80
            let message = self.messages[indexPath.row]
            if let text = message.text{
                // get estimate height of text
                let frameText = text.estimateFrameOfString()
                height = frameText.height + 20
            }else{
                // solve height without text
                if let imageHeight = message.imageHeight?.floatValue, let imageWidth = message.imageWidth?.floatValue {
                    // newHeight = oldHeight / oldWidth * newWidth
                    height = CGFloat(imageHeight / imageWidth * 250)
                }
            }
            size = CGSize(width: view.frame.width, height: height)
        }else{
            // photoLibraryCollectionView
            let height = collectionView.frame.height
            size = CGSize(width: height, height: height)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 1{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
}

