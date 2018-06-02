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
    var contacts:[Contact]?
    var ref:DatabaseReference!
    var currentUser:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        ref = Database.database().reference()
        
        observeCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getListContactsId { (contactsId) in
            self.observerContacts(constantsId: contactsId)
        }
        observeGetLengthContactsRequest()
    }
    
    // MARK:- Private instance methods
    private func observeCurrentUser(){
        if let currentUID = Auth.auth().currentUser?.uid{
            ref.child("users").child(currentUID).observe(.value, with: { (snapshot) in
                self.currentUser = User()
                self.currentUser?.id = currentUID
                self.currentUser?.setValueForKeys(values: snapshot.value as! [String : Any])
                self.currentUser?.setContactsRequest(snapshot: snapshot)
                self.currentUser?.setContacts(snapshot: snapshot)
            })
        }
    }
    
    private func getListContactsId(completeHandle:((_ result: [String]) -> ())?){
        if let uid = Auth.auth().currentUser?.uid{
            ref.child("users").child(uid).child("contacts").observe(.value, with: { (snapshot) in
                let childrens = snapshot.children.allObjects as? [DataSnapshot]
                var contactsId = [String]()
                for child in childrens!{
                    contactsId.append(child.value as! String)
                }
                completeHandle?(contactsId)
            })
        }
    }
    private func observerContacts(constantsId:[String]){
        // reload data, if don't reload table will duplicate contact
        self.contacts = [Contact]()
        self.contactsTableView.reloadData()
        // get contacts by contactsId
        for contactId in constantsId{
            ref.child("users").child(contactId).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as! [String: Any]
                let contact = Contact()
                contact.setValueForKeys(dict: value)
                self.contacts!.append(contact)
                DispatchQueue.main.async {
                    self.contactsTableView.reloadData()
                }
            })
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    private func observeGetLengthContactsRequest(){
        if let uid = Auth.auth().currentUser?.uid{
            ref.child("users").child(uid).child("contactsRequest").observe(.value, with: { (snapshot) in
                let count = snapshot.childrenCount
                self.notificationRequestLabel.text = "\(count)"
            })
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
        self.present(addNewContactViewController, animated: true, completion: nil)
    }
    
}

// MARK:- UITableViewDatasource
extension ContactsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ContactsTableViewCell
        cell?.contact = self.contacts?[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

// MARK:- UITableViewDelegate
extension ContactsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let blockAction = UITableViewRowAction(style: .destructive, title: "Block") { (action, indexPath) in
            // do some thing
        }
        return [blockAction]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}





