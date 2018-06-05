//
//  ContactsViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/31/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ContactsViewController : UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var notificationRequestLabel: UILabel!
    @IBOutlet weak var contactsTableView: UITableView!
    
    let cellId = "cellId"
    var contacts = [Contact]()
    var currentUser:User!
    
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        observeCurrentUser()
        observeContacts()
        observeGetLengthContactsRequest()
    }
    
    // MARK:- Private instance methods
    private func observeCurrentUser(){
        if let currentUID = Auth.auth().currentUser?.uid{
           let userRef = Database.database().reference().child("users").child(currentUID)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                self.currentUser = User()
                self.currentUser?.id = currentUID
                self.currentUser?.setValueForKeys(values: snapshot.value as! [String : Any])
                self.currentUser?.setContactsRequest(snapshot: snapshot)
                self.currentUser?.setContacts(snapshot: snapshot)
                self.currentUser?.setListBlocked(snapshot: snapshot)
            })
        }
    }

    private func observeContacts(){
        if let uid = Auth.auth().currentUser?.uid{
            let contactsRef = Database.database().reference().child("users").child(uid).child("contacts")
            contactsRef.observe(.value) { (snapshot) in
                let childrens = snapshot.children.allObjects as! [DataSnapshot]
                self.contacts = [Contact]()
                if childrens.count > 0{
                    for child in childrens{
                        let contactId = child.value as! String
                        self.fetchContactWithContactId(contactId: contactId)
                    }
                }else{
                    DispatchQueue.main.async {
                        // user don't have any contact
                        // when switch user table must reload data, if don't reload table view will show contacts of after user
                        self.contactsTableView.reloadData()
                    }
                }
            }
        }
    }

    private func fetchContactWithContactId(contactId:String?){
        if let contactId = contactId{
            let contactRef = Database.database().reference().child("users").child(contactId)
            contactRef.observeSingleEvent(of: .value) { (snapshot) in
                if let values = snapshot.value as? [String:Any]{
                    // get contact to add array contacts
                    let contact = Contact()
                    contact.id = snapshot.key
                    contact.setValueForKeys(dict: values)
                    self.contacts.append(contact)
                    // reload data
                    DispatchQueue.main.async {
                        self.contactsTableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }

    private func observeGetLengthContactsRequest(){
        if let uid = Auth.auth().currentUser?.uid{
            let countContactsRequestRef = Database.database().reference().child("users").child(uid).child("contactsRequest")
            countContactsRequestRef.observe(.value, with: { (snapshot) in
                let count = snapshot.childrenCount
                self.notificationRequestLabel.text = "\(count)"
            })
        }
    }
    
    private func getContactByUnwindClosure(contact:Contact?){
        // push to chatLogViewController
        if let contact = contact {
            // push to chatLogViewController
            let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogViewController.contact = contact
            chatLogViewController.currentUser = self.currentUser
            self.navigationController?.pushViewController(chatLogViewController, animated: true)
        }
    }
    
    // MARK: Actions
    @IBAction func pushToRequestViewController(_ sender: UIButton) {
        // init contactRequestVC to push that vc
        let contactRequestViewController = ContactsRequestTableViewController(nibName: "ContactsRequestTableViewController", bundle: nil)
        contactRequestViewController.currentUser = self.currentUser
        self.navigationController?.pushViewController(contactRequestViewController, animated: true)
    }
    
    @IBAction func addNewContact(_ sender: UIButton) {
        let addNewContactViewController = AddNewContactViewController(nibName: "AddNewContactViewController", bundle: nil)
        addNewContactViewController.modalPresentationStyle = .overCurrentContext
        addNewContactViewController.currentUser = self.currentUser
        addNewContactViewController.unwindWithContactIsAlready = getContactByUnwindClosure(contact:)
        self.present(addNewContactViewController, animated: true, completion: nil)
    }
    
}

// MARK:- UITableViewDatasource
extension ContactsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ContactsTableViewCell
        cell?.contact = self.contacts[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

// MARK:- UITableViewDelegate
extension ContactsViewController : UITableViewDelegate {
    
    private func blockContact(currentUser: User, contactWillBlock: Contact){
        // add contact to list blocked of current user
        // and contact blocked also add current user to list blocked
        Database.database().reference().child("users").child(currentUser.id).child(Define.CONTACTS_BLOCKED).childByAutoId()
            .setValue(contactWillBlock.id)
        // call func observeCurrentUser to refresh data
        self.observeCurrentUser()
    }
    
    private func getKeyContactUnblock(fromId: String, toId: String, completeHandle:@escaping (_ key:String?) -> ()){
        // remove contact in list blocked of current user
      let keyContactUnblockRef = Database.database().reference().child("users").child(fromId).child(Define.CONTACTS_BLOCKED)
        keyContactUnblockRef.observeSingleEvent(of: .value) { (snapshot) in
            let childrens = snapshot.children.allObjects as? [DataSnapshot]
            if let childrens = childrens{
                // loop to get key element have value equal contactIdWillUnblock
                for child in childrens{
                    if child.value as! String == toId{
                        completeHandle(child.key)
                        return
                    }
                }
                completeHandle(nil)
            }
        }
    }
    
    private func unblockContact(fromId:String, toId: String){
        getKeyContactUnblock(fromId: fromId, toId: toId) { (key) in
            if let key = key {
                // remove contact blocked by key
                let removeBlockRef = Database.database().reference().child("users").child(fromId).child(Define.CONTACTS_BLOCKED)
                removeBlockRef.child(key).removeValue()
                self.contactsTableView.reloadData()
                // call func observeCurrentUser to refresh data
                self.observeCurrentUser()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var action:UITableViewRowAction!
        let contact = self.contacts[indexPath.row]
        if let currentUser = self.currentUser{
            action = UITableViewRowAction(style: .destructive, title: "Block".localized, handler: { (action, indexPath) in
                self.blockContact(currentUser: currentUser, contactWillBlock: contact)
            })
            for contactId in currentUser.listBlocked!{
                // if contact id in list blocked of current user, the action will init to unblock
                if contact.id == contactId{
                    action = UITableViewRowAction(style: .default, title: "Unblock".localized, handler: { (action, indexPath) in
                        self.unblockContact(fromId: currentUser.id, toId: contact.id)
                    })
                    action.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    break
                }
            }
        }
        return [action]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = self.contacts[indexPath.row]
        // push to chatLogViewController
        let chatLogViewController = ChatLogViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogViewController.contact = contact
        chatLogViewController.currentUser = self.currentUser
        self.navigationController?.pushViewController(chatLogViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}





