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

private let appLanguagesKey = "AppleLanguages"

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
            user.setContactsRequest(snapshot: snapshot)
            user.setContacts(snapshot: snapshot)
            // load profile user
            self.parseUserProfile(user: user)
        }
    }
    
    fileprivate func showAlertToUpdateUserName(){
        let alert = UIAlertController(title: "Edit username".localized, message: "Do you want to edit your name".localized, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Your name".localized
        })
        let changeAction = UIAlertAction(title: "Change".localized, style: .default, handler: { (action) in
            if let username = alert.textFields?.first?.text {
                // update username
                if let uid = Auth.auth().currentUser?.uid {
                    self.ref.child("users/\(uid)/name").setValue(username)
                }
            }
        })
        alert.addAction(changeAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func checkCurrentLanguageToChange(languageWillChange: Language){
        let currentLanguage = Language.language
        if currentLanguage == languageWillChange{
            self.presentAlertWithoutAction(title: "Sorry".localized, and: "The current language is language you selected".localized, completion: nil)
        }else{
            self.presentAlertWithoutAction(title: "Changed".localized, and: "You must restart app that it will change language of app".localized, completion: nil)
            Language.language = languageWillChange
        }
        
    }
    
    fileprivate func showAlertToSelectLanguage(){
        let alert = UIAlertController(title: "Select language".localized, message: nil, preferredStyle: .actionSheet)
        // init action language
        // if current language not equal language selected, it will show alert requied restart app
        // else return don't do anything
        let enAction = UIAlertAction(title: "English", style: .default) { (action) in
            self.checkCurrentLanguageToChange(languageWillChange: Language.english)
        }
        let viAction = UIAlertAction(title: "Vietnamese", style: .default) { (action) in
            self.checkCurrentLanguageToChange(languageWillChange: Language.vietnamese)
        }
        alert.addAction(enAction)
        alert.addAction(viAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func handleChangePassword(oldPass:String, newPass:String, confirmPass: String){
        if newPass != confirmPass {
            self.presentAlertWithoutAction(title: "Wrong", and: "Confirm password don't match with new password", completion: nil)
        }else{
            let user = Auth.auth().currentUser
            if let email = self.userInfos?[1].content{
                let credential = EmailAuthProvider.credential(withEmail: email, password: oldPass)
                user?.reauthenticate(with: credential, completion: { (error) in
                    if error != nil{
                        self.presentAlertWithoutAction(title: "Error", and: (error?.localizedDescription)!, completion: nil)
                        return
                    }
                    // change to new password
                    user?.updatePassword(to: newPass, completion: { (error) in
                        if error != nil {
                            self.presentAlertWithoutAction(title: "Error".localized, and: (error?.localizedDescription)!, completion: nil)
                            return
                        }else{
                            self.presentAlertWithoutAction(title: "Success".localized, and: "Change password was successful!".localized, completion: nil)
                        }
                    })
                })
            }
        }
        
    }
    
    private func showAlertToChangePassword(){
        let alertViewController = UIAlertController(title: "Change password".localized, message: "Do you want to change password".localized, preferredStyle: .alert)
        // add some text field
        alertViewController.addTextField { (oldPasswordTextField) in
            oldPasswordTextField.placeholder = "Old password".localized
            oldPasswordTextField.isSecureTextEntry = true
        }
        alertViewController.addTextField { (newPasswordTextField) in
            newPasswordTextField.placeholder = "New password".localized
            newPasswordTextField.isSecureTextEntry = true
        }
        alertViewController.addTextField { (confirmPasswordTextField) in
            confirmPasswordTextField.placeholder = "Confirm password".localized
            confirmPasswordTextField.isSecureTextEntry = true
        }
        // add  2 actions
        let changeAction = UIAlertAction(title: "Change".localized, style: .default) { (action) in
            if let oldPassword = alertViewController.textFields?.first?.text,
                let newPassword = alertViewController.textFields?[1].text,
                let confirmPassword = alertViewController.textFields?.last?.text {
                self.handleChangePassword(oldPass: oldPassword, newPass: newPassword, confirmPass: confirmPassword)
            }
        }
        alertViewController.addAction(changeAction)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    private func handleLogoutUser(){
        do {
            try Auth.auth().signOut()
        }catch let error{
            print(error)
        }
        let loginViewController = LoginViewController()
        // save user isn't logged in
        UserDefaults.standard.setIsLoggedIn(value: false)
        present(loginViewController, animated: true, completion: nil)
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
            UserInfo(bubbleColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), icon: #imageLiteral(resourceName: "locked"), title: "Change password".localized, content: ""),
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
        if indexPath.row != 1{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showAlertToUpdateUserName()
        case 1: // don't allow to change email
            break
        case 2:
            let championsViewController = ChampionsViewController(nibName: "ChampionsViewController", bundle: nil)
            championsViewController.modalPresentationStyle = .overCurrentContext
            championsViewController.championDelegate = self
            present(championsViewController, animated: true, completion: nil)
        case 3:
            showAlertToSelectLanguage()
        case 4:
            showAlertToChangePassword()
        case 5:
            // logout user
            handleLogoutUser()
        default:
            return
        }
    }
}

// MARK:- ChampionDelegate
extension UserViewController : ChampionDelegate{
    
    func selectedChampion(champion: Champion) {
        // update champion favorite
        if let uid = Auth.auth().currentUser?.uid{
            self.ref.child("users/\(uid)/championName").setValue(champion.name)
            self.ref.child("users/\(uid)/championUrlImage").setValue(champion.imageUrl)
        }        
    }
    
    
    
    
}
