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
    var currentUser:User?
    var messageDictionary:[String: Message]?
    var messages:[Message]?
    var oldUid:String?
    
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        self.tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        // init right bar button item
        let newMessageButton = UIBarButtonItem(image: #imageLiteral(resourceName: "add"), style: .done, target: self, action: #selector(showNewMessageTableViewController))
        self.navigationItem.rightBarButtonItem = newMessageButton
        
        messageDictionary = [String: Message]()
        fetchUser()
        observeUserMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if oldUid != nil{
            if uid != oldUid{
                // if oldUid not equal current uid, it mean user switched account
                // so must refresh message dictionary
                self.messageDictionary = [String: Message]()
                self.tableView.reloadData()
                fetchUser()
                observeUserMessage()
            }
        }
        // keep uid by oldUid
        self.oldUid = uid
    }
    
    // MARK:- Private instance methods
    private func fetchUser(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observe(.value) { (snapshot) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
            let userMessageRef = Database.database().reference()
            userMessageRef.child("user-messages").child(uid).observe(.childAdded, with: { (snapshot) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                // get contact id, then observe user-messages with this contact id
                let contactId = snapshot.key
                self.fetchMessageWithContactId(contactId: contactId, with: uid)
            })
        }
    }
    
    private func fetchMessageWithContactId(contactId:String, with uid:String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        Database.database().reference().child("user-messages").child(uid).child(contactId).child("messages").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) in
            // get message id
            let messageId = snapshot.key
            // make ref to message by message id
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let message = Message(values: dictionary)
                    // set row once for a person
                    if let toId = message.chatParterId(){
                        self.messageDictionary![toId] = message
                        self.messages = Array(self.messageDictionary!.values)
                        // sort message by timestamp
                        self.messages?.sort(by: { (m1, m2) -> Bool in
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
        return self.messages?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell
        let message = self.messages?[indexPath.row]
        setupNameAndProfileImage(message: message!, for: cell!)
        cell?.message = message
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    private func setupNameAndProfileImage(message:Message, for cell: MessageTableViewCell){
        cell.profileImageView.image = nil
        cell.userNameLabel.text = ""
        if let contactId = message.chatParterId(){
            Database.database().reference().child("users").child(contactId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let values = snapshot.value as? [String : Any]{
                    let contact = Contact()
                    contact.setValueForKeys(dict: values)
                    DispatchQueue.main.async {
                        cell.userNameLabel.text = contact.name
                        cell.profileImageView.loadImageUsingCacheWithUrl(urlString: contact.championUrlImage!)
                    }
                }
            })
        }
    }

}
// MARK:- UITableViewDelegate
extension MessagesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messages = Array(self.messageDictionary!.values)
        let message = messages[indexPath.row]
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
    
    private func deleteAChat(messageForItem indexPath: IndexPath){
        if let uid = Auth.auth().currentUser?.uid{
            let messages = Array(self.messageDictionary!.values)
            let message = messages[indexPath.row]
            // get chat parter id
            if let chatParterId = message.chatParterId(){
                let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(chatParterId)
                userMessageRef.child("messages").removeValue(completionBlock: { (error, dataRef) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    // remove message in message dictionary
                    // deleted, so reload data
                    self.messages?.remove(at: indexPath.row)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteAChat(messageForItem: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

