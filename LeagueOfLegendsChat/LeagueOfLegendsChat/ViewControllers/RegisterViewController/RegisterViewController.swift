//
//  RegisterViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var avatarChampionImage: UIImageView!
    @IBOutlet weak var championNameLabel: UILabel!
    
    var auth:Auth!
    var champion: Champion?
    var ref: DatabaseReference!
    
    @IBOutlet weak var bottomRegisterViewConstaint: NSLayoutConstraint!
    @IBOutlet weak var heightLogoImageConstaint: NSLayoutConstraint!
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate for textfields
        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        auth = Auth.auth()
        ref = Database.database().reference()
        
        // setup notification center
        setupNotificationCenter()
    }
    
    // MARK: - Private instance methods
    private func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    private func registerAccount(){
        // handle register account
        guard let email = emailTextField.text,
            let name = nameTextField.text,
            let password = passwordTextField.text,
            let championName = champion?.name,
            let championUrlImage = champion?.imageUrl else { return }
        auth.createUser(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error!)
                return
            }
            // get uid to saved in fbdatabase
            if let uid = user?.uid{
                let values = [Define.USER_NAME: name, Define.USER_EMAIL: email, Define.USER_CHAMPION_NAME: championName, Define.USER_CHAMPION_URL_IMAGE: championUrlImage]
                self.registerUserIntoFirebaseDatabaseWithUID(uid: uid, values: values)
            }
        }
    }
    private func registerUserIntoFirebaseDatabaseWithUID(uid: String, values:[String: Any]){
        self.ref.child("users").child(uid).updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    

    // MARK:- Actions

    @IBAction func showChampionsCollectionView(_ sender: UIButton) {
        let championsViewController = ChampionsViewController(nibName: "ChampionsViewController", bundle: nil)
        championsViewController.modalPresentationStyle = .overCurrentContext
        championsViewController.championDelegate = self
        self.present(championsViewController, animated: true, completion: nil)
    }
    
    @IBAction func dismissSelf(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleRegisterAccount(_ sender: UIButton) {
        if emailTextField.text == "" || nameTextField.text == "" || passwordTextField.text == "" || confirmPasswordTextField.text == "" || championNameLabel.text == " "{
            self.presentAlertWithoutAction(title: "Waring", and: "You must enter enough info!")
        }else{
            // if confirmPassword not equal password, it will don't allow register account
            if confirmPasswordTextField.text != passwordTextField.text{
                // show waring message to user
                confirmPasswordTextField.isSecureTextEntry = false
                confirmPasswordTextField.text = "Don't match password"
                confirmPasswordTextField.textColor = UIColor.red
            }else{
                registerAccount()
            }
        }
    }
    
    @objc func handleKeyboardNotification(notification:Notification){
        if let userInfo = notification.userInfo{
            // get frame of keyboard
            let frameKeyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            let heightKeyboard = frameKeyboard.height
            bottomRegisterViewConstaint.constant = isKeyboardShowing ? -heightKeyboard :  24
            heightLogoImageConstaint.constant = isKeyboardShowing ? 0 : 128
            // animate
            UIView.animate(withDuration: 0.5, delay: 0.01, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}

// MARK:- ChampionDelegate
extension RegisterViewController: ChampionDelegate{
    
    func selectedChampion(champion: Champion) {
        // clear background
        avatarChampionImage.backgroundColor = UIColor.clear
        // load image
        avatarChampionImage.loadImageUsingCacheWithUrl(urlString: champion.imageUrl!)
        championNameLabel.text = champion.name!
        self.champion = champion
    }
    
}

// MARK:- UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(confirmPasswordTextField){
            confirmPasswordTextField.text = ""
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPasswordTextField.textColor = UIColor.black
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}








