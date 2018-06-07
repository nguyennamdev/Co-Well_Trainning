//
//  MessageTableViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MessagesTableViewController: UITableViewController {
    
    let cellId = "cellId"
    
    var ref: DatabaseReference!
    var messages = [Message]()
    var currentUser:User?
    var messageDictionary = [String: Message]()
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        self.tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        // init right bar button item
        let newMessageButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .done, target: self, action: #selector(showNewMessageTableViewController))
        self.navigationItem.rightBarButtonItem = newMessageButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUser()
        observeUserMessage()
    }
    
    // MARK:- Private instance methods
    private func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).observe(.value) { (snapshot) in
            // get user value
            let values = snapshot.value as? [String: Any]
            let user = User()
            user.id = snapshot.key
            user.setValueForKeys(values: values!)
            self.navigationItem.title = user.name
            self.currentUser = user
        }
    }
    
    private func observeUserMessage(){
        if let uid = Auth.auth().currentUser?.uid {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let userMessageRef = Database.database().reference().child("user-messages").child(uid)
            userMessageRef.observe(.childAdded, with: { (snapshot) in
                let contactId = snapshot.key
                self.fetchMessageWithContactId(uid: uid, contactId: contactId)
            })
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    private func fetchMessageWithContactId(uid:String,contactId:String){
        Database.database().reference().child("user-messages").child(uid).child(contactId).child("messages").observe(.childAdded, with: { (snapshot) in
            // get message id
            let messageId = snapshot.key
            // make ref to message by message id
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let message = Message()
                    message.setValueForKeys(values: dictionary)
                    // set row once for a person
                    if let toId = message.chatParterId(){
                        self.messageDictionary[toId] = message
                        self.messages = Array(self.messageDictionary.values)
                        // sort by timestamp
                        self.messages.sort(by: { (m1, m2) -> Bool in
                            return m1.timestamp.intValue > m2.timestamp.intValue
                        })
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
        }, withCancel: nil)
     
    }
    
    private func showChatLogWithContact(contact:Contact){
        if let currentUser = self.currentUser{
            let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogViewController.contact = contact
            chatLogViewController.currentUser = currentUser
            self.navigationController?.pushViewController(chatLogViewController, animated: true)
        }
    }
    
    // MARK:- Actions
    @objc private func showNewMessageTableViewController(){
        if let currentUser = self.currentUser{
            let newMessageTableViewController = NewMessageTableViewController(nibName: "NewMessageTableViewController", bundle: nil)
            newMessageTableViewController.currentUser = currentUser
            self.navigationController?.pushViewController(newMessageTableViewController, animated: true)
        }
    }
    
}

// MARK:- UITableViewDataSource
extension MessagesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell
        cell?.message = self.messages[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.messages[indexPath.row]
        if let chatParterId = message.chatParterId(){
            // get contact will chat
            let contactRef = Database.database().reference().child("users").child(chatParterId)
            contactRef.observe(.value, with: { (snapshot) in
                if let values = snapshot.value as? [String: Any]{
                    let contact = Contact()
                    contact.id = snapshot.key
                    contact.setValueForKeys(dict: values)
                    self.showChatLogWithContact(contact: contact)
                }
            })
        }
    }
    
    
}
