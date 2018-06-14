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
            let message = self.messages[indexPath.row]
            cell?.message = message
            cell?.contact = self.contact
            cell?.chatMessageDelegate = self
            // setup bubble view color
            if message.fromId == self.currentUser?.id{
                cell?.bubbleView.backgroundColor = self.bubbleColor ?? #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            }
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
    
    private func setupSizeForChatCell(sizeForItemAt indexPath:IndexPath) -> CGSize{
        let message = self.messages[indexPath.row]
        var height:CGFloat = 40
        // handle height when message is text
        if let text = message.text{
            height = text.estimateFrameOfString().height + 20
        }
        // get width and height original image, when message isn't text
        if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            if message.imageUrl != nil{
                /* height when message is image
                solve height cell
                h1 / w1 = h2 / w2 */
                height = CGFloat(imageHeight / imageWidth * 250) // 250 = w2
            }else if message.stickerUrl != nil{
                // height when message is sticker
                height = CGFloat(imageHeight / imageWidth * 150)
            }
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 0:
            return setupSizeForChatCell(sizeForItemAt: indexPath)
        case 1:
            // photoLibraryCollectionView
            let height = collectionView.frame.height
            return CGSize(width: height, height: height)
        case 2:
            // stickerCollectionView
            let width = view.frame.width / 5
            return CGSize(width: width, height: width)
        default:
            break
        }
        return CGSize(width: 0, height: 0)
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
            self.updateFileToFirebaseUsingImage(image: sticker, quantityImage: 1, completion: { (stickerUrl) in
                if let stickerUrl = stickerUrl {
                    self.sendMessageWithSticker(stickerUrl: stickerUrl, stickerImage: sticker)
                }
            })
        }
    }
    
}


