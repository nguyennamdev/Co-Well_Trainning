//
//  NewMessageTableViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

private let cellId = "cellId"
class NewMessageTableViewController: UITableViewController {
    
    var contacts:[Contact] = [Contact]()
    var currentUser:User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // custom back button
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .plain, target: self, action: #selector(backToRootView))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "New message".localized
        
        // use class MessageTableViewCell to self cell
        self.tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        observeContacts()
    }
    
    // MARK:- Private instance methods
    private func observeContacts(){
        if let uid = Auth.auth().currentUser?.uid {
            let contactIdRef = Database.database().reference().child("users").child(uid).child("contacts")
            contactIdRef.observe(.childAdded, with: { (snapshot) in
                let contactId = snapshot.value as! String
                let contactRef = Database.database().reference().child("users").child(contactId)
                contactRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any]{
                        let contact = Contact()
                        contact.id = snapshot.key
                        contact.setValueForKeys(dict: dictionary)
                        self.contacts.append(contact)
                        // reload data
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
            })
        }
    }
    
    // MARK:- Actions
    @objc private func backToRootView(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK:- UITableViewDatasource
extension NewMessageTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell
        let contact = self.contacts[indexPath.row]
        cell?.contact = contact
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentUser = self.currentUser{
            let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogViewController.contact = self.contacts[indexPath.row]
            chatLogViewController.currentUser = currentUser
            self.navigationController?.pushViewController(chatLogViewController, animated: true)
        }
    }
    
}
