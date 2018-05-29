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

    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUser()
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
        }
    }
    
    // MARK:- Actions
    
    
    
}

// MARK:- UITableViewDataSource
extension MessagesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    }
}
