//
//  ContactsResquestDelegate.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

protocol ContactsRequestDelegate {
    
    func responseToContactRequest(isAccept:Bool, with contactRequestId:String)
    
}
