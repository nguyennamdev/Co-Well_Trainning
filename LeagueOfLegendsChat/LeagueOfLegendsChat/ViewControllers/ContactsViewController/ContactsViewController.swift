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
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    let cellId = "cellId"
    var contacts:[User] = [User]()
    var ref:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        ref = Database.database().reference()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListContactsId { (contactsId) in
            self.observerContacts(constantsId: contactsId)
        }
    }
    
    // MARK:- Private instance methods
    private func getListContactsId(completeHandle:((_ result: [String]) -> ())?){
        if let uid = Auth.auth().currentUser?.uid{
            ref.child("users/\(uid)/contacts").observe(.value, with: { (snapshot) in
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
        self.contacts.removeAll()
        self.contactsTableView.reloadData()
        
        for contactId in constantsId{
            ref.child("users/\(contactId)").observe(.value, with: { (snapshot) in
                let value = snapshot.value as! [String: Any]
                let contact = User()
                contact.setValueForKeys(values: value)
                self.contacts.append(contact)
                DispatchQueue.main.async {
                     self.contactsTableView.insertRows(at: [IndexPath(row: self.contacts.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
                }
            })
        }
    }
    
    // MARK: Actions
    @IBAction func pushToRequestViewController(_ sender: UIButton) {
        print("request")
    }
    
    @IBAction func addNewContact(_ sender: UIButton) {
        let addNewContactViewController = AddNewContactViewController(nibName: "AddNewContactViewController", bundle: nil)
        addNewContactViewController.modalPresentationStyle = .overCurrentContext
        self.present(addNewContactViewController, animated: true, completion: nil)
    }
    
}

// MARK:- UITableViewDatasource
extension ContactsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ContactsTableViewCell
        cell?.contact = self.contacts[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

// MARK:- UITableViewDelegate
extension ContactsViewController : UITableViewDelegate {
    
    
    
}





