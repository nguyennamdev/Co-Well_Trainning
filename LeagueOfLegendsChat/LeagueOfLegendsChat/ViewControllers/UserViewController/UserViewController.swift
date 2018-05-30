//
//  UserViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/29/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserViewController: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var profileUserTableView: UITableView!
    @IBOutlet weak var championName: UILabel!
    @IBOutlet weak var championFavotiteImageView: UIImageView!
    var ref:DatabaseReference!
    var userInfos:[UserInfo]?
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        // setup for table
        profileUserTableView.dataSource = self
        profileUserTableView.delegate = self
        profileUserTableView.register(UserProfileTableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    // MARK:- Private instance methods
    private func fetchUser(){
        // show activity indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).observe(.value) { (snapshot) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            // get user value
            let values = snapshot.value as? [String: Any]
            let user = User()
            user.id = snapshot.key
            user.setValueForKeys(values: values!)
            // load profile user
            self.parseUserProfile(user: user)
        }
    }
    
    private func parseUserProfile(user:User){
        self.championFavotiteImageView.loadImageUsingCacheWithUrl(urlString: user.championUrlImage!)
        self.championName.text = user.championName
        // load profile assign to table view
        self.userInfos = [
            UserInfo(bubbleColor: UIColor.red, icon: #imageLiteral(resourceName: "user"), title: "Username".localized, content: user.name),
            UserInfo(bubbleColor: UIColor.green, icon: #imageLiteral(resourceName: "at"), title: "Mail".localized, content: user.email),
            UserInfo(bubbleColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), icon: #imageLiteral(resourceName: "Kai'Sa"), title: "Favorite Champion".localized, content: user.championName),
            UserInfo(bubbleColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), icon: #imageLiteral(resourceName: "translate"), title: "Select language app".localized, content: ""),
            UserInfo(bubbleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), icon: #imageLiteral(resourceName: "logout"), title: "Logout".localized, content: "")
        ]
        self.profileUserTableView.reloadData()
    }
    
}

// MARK:- UITableViewDataSource
extension UserViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userInfos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as? UserProfileTableViewCell
        if indexPath.row != 2{
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        cell?.userInfo = self.userInfos?[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
// MARK:- UITableViewDelegate
extension UserViewController : UITableViewDelegate{
    
    private func showAlertToUpdateUserName(){
        let alert = UIAlertController(title: "Edit username".localized, message: "Do you want to edit your name".localized, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Your name".localized
        })
        let changeAction = UIAlertAction(title: "Change".localized, style: .default, handler: { (action) in
            //
        })
        alert.addAction(changeAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
          showAlertToUpdateUserName()
        default:
            return
        }
    }
   
    
}
