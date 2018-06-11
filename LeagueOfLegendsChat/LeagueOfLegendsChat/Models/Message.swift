//
//  Message.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import FirebaseAuth

class Message  {

    var fromId:String!
    var toId:String!
    var text:String?
    var timestamp:NSNumber!
    var imageUrl:String?
    var imageWidth:NSNumber?
    var imageHeight:NSNumber?
    var videoUrl:String?
    var stickerUrl:String?
    
    func chatParterId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    init(values:[String: Any]) {
        self.toId = values[Define.TO_ID] as! String
        self.fromId = values[Define.FROM_ID] as! String
        self.text = values[Define.TEXT] as? String
        self.timestamp = values[Define.TIMESTAMP] as! NSNumber
        self.imageUrl = values[Define.IMAGE_URL] as? String
        self.imageWidth = values[Define.IMAGE_WIDTH] as? NSNumber
        self.imageHeight = values[Define.IMAGE_HEIGHT] as? NSNumber
        self.videoUrl = values[Define.VIDEO_URL] as? String
        self.stickerUrl = values[Define.STICKER_URL] as? String
    }
    
}
