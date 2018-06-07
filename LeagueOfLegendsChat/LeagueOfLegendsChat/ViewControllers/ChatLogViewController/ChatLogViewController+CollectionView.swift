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
        switch collectionView.tag {
        case 0:
            return self.messages.count
        case 1:
            return self.images.count
        case 2:
            return self.stickerImages.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? ChatMessageCollectionViewCell
            cell?.message = self.messages[indexPath.row]
            cell?.contact = self.contact
            cell?.chatMessageDelegate = self
            return cell!
        case 1:
            // photoLibraryCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoLibraryCollectionViewCell
            cell?.chatMessageDelegate = self
            cell?.image = self.images[indexPath.row]
            return cell!
        case 2:
            // stickerCollectionView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stickerCell", for: indexPath) as? StickerCollectionViewCell
            cell?.stickerImage = self.stickerImages[indexPath.row]
            return cell!
        default:
            return UICollectionViewCell()
        }
    }
    
}
// MARK:- UICollectionViewDelegateFlowLayout
extension ChatLogViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size:CGSize = CGSize()
        switch collectionView.tag {
        case 0:
            var height:CGFloat = 80
            let message = self.messages[indexPath.row]
            if let text = message.text{
                // get estimate height of text
                let frameText = text.estimateFrameOfString()
                height = frameText.height + 20
            }else{
                // solve height without text
                if let imageHeight = message.imageHeight?.floatValue, let imageWidth = message.imageWidth?.floatValue
                {
                    var newWidth:Float = 250 // default new width
                    if message.stickerUrl != nil{
                        // if message is sticker new width will smaller
                        newWidth = 150
                    }
                    // newHeight = oldHeight / oldWidth * newWidth
                    height = CGFloat(imageHeight / imageWidth * newWidth)
                }
            }
            size = CGSize(width: view.frame.width, height: height)
        case 1:
            // photoLibraryCollectionView
            let height = collectionView.frame.height
            size = CGSize(width: height, height: height)
        case 2:
            // stickerCollectionView
            let width = view.frame.width / 5
            size = CGSize(width: width, height: width)
        default:
            break
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 0{
            return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        }else if collectionView.tag == 1{
             return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        }
    }
}

// MARK: CollectionViewDelegate
extension ChatLogViewController {
    
   override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2{
            // it is stickers collection view
            // send sticker
            let sticker = self.stickerImages[indexPath.row]
            self.updateFileToFirebaseUsingImage(image: sticker, completion: { (stickerUrl) in
                self.sendMessageWithSticker(stickerUrl: stickerUrl, stickerImage: sticker)
            })
        }
    }
    
}


