//
//  ContactsRequestTableViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/2/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ContactsRequestTableViewController: UITableViewController {
    
    let cellId = "cellId"
    let TITLE_SECTION = "Open a request to get more info about who's messaging you. They won't know you've seen it until you accept".localized
    var ref:DatabaseReference!
    var contactsRequest:[Contact]?
    var currentUser:User?
    
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Requests".localized
        
        tableView.register(UINib(nibName: "ContactRequestTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        ref = Database.database().reference()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    // MARK:- Private instance methods
    private func loadData(){
        // reload data, if don't reload table will duplicate contact
        self.contactsRequest = [Contact]()
        self.tableView.reloadData()
        if let currentUID = Auth.auth().currentUser?.uid{
            getListContactsIdRequest(by: currentUID, completeHandle: { (contactsIdRequest) in
                self.observeContactsRequest(contactsIdRequest: contactsIdRequest)
            })
        }
    }
    
    
    private func getListContactsIdRequest(by userId:String, completeHandle:((_ contactsRequest:[String]) -> ())?){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ref.child("users").child(userId).child("contactsRequest").observe(.value, with: { (snapshot) in
            let childrens = snapshot.children.allObjects as! [DataSnapshot]
            var contactsResult = [String]()
            for children in childrens{
                contactsResult.append(children.value as! String)
            }
            completeHandle!(contactsResult)
        })
    }
    
    private func observeContactsRequest(contactsIdRequest:[String]){
        for contactId in contactsIdRequest{
            let contactRef = Database.database().reference().child("users").child(contactId)
            contactRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! [String: Any]
                let contact = Contact()
                contact.id = snapshot.key
                contact.setValueForKeys(dict: value)
                self.contactsRequest!.append(contact)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    private func getKeyOfContactRequestWillRemove(userId:String,with contactIdWillRemove:String, completeHandle:@escaping (String?) -> ()){
        let contactsRequestRef = Database.database().reference().child("users").child(userId).child("contactsRequest")
        contactsRequestRef.observe(.value) { (snapshot) in
            let childrens = snapshot.children.allObjects as? [DataSnapshot]
            if let childrens = childrens{
                // loop to get key element have value equal contactIdWillRemove
                for child in childrens{
                    if child.value as! String == contactIdWillRemove{
                        completeHandle(child.key)
                        return
                    }
                }
                completeHandle(nil)
            }
        }
    }
    
    private func removeContactRequestByKey(userId: String, contactIdWillRemove: String){
        getKeyOfContactRequestWillRemove(userId: userId, with: contactIdWillRemove) { (key) in
            if let key = key{
                let dispathGroup = DispatchGroup()
                dispathGroup.enter()
                let ref = Database.database().reference().child("users").child(userId).child(Define.CONTACT_REQUEST).child(key)
                ref.removeValue(completionBlock: { (error, ref) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    dispathGroup.leave()
                })
                dispathGroup.notify(queue: DispatchQueue.main, execute: {
                    self.loadData()
                })
            }
        }
    }
    
}

// MARK: - Table view data source
extension ContactsRequestTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsRequest?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactRequestTableViewCell
        cell.contactRequest = self.contactsRequest?[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.acceptButton.isEnabled = true
        cell.disacceptButton.isEnabled = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TITLE_SECTION
    }
    
}

// MARK:- Implement ContactsRequestDelegate
extension ContactsRequestTableViewController : ContactsRequestDelegate{
    
    func responseToContactRequest(isAccept: Bool, with contactRequestId: String) {
        if let currentUser = currentUser{
            if isAccept{
                // move contactRequestId to list contact of current user. because user accepted to chat
                let userAcceptRef = Database.database().reference().child("users").child(currentUser.id!).child("contacts")
                userAcceptRef.childByAutoId().setValue(contactRequestId)
                // in addition contact request also add current user id to list contact
                let contactRef = Database.database().reference().child("users").child(contactRequestId).child("contacts")
                contactRef.childByAutoId().setValue(currentUser.id!)
            }
            removeContactRequestByKey(userId: currentUser.id!, contactIdWillRemove: contactRequestId)
            removeContactRequestByKey(userId: contactRequestId, contactIdWillRemove: currentUser.id)
        }
    }
    
    
}


