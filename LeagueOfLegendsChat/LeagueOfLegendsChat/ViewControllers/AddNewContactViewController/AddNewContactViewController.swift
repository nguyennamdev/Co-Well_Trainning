//
//  AddNewContactViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/31/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddNewContactViewController: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var alertView: UIView!

    var ref:DatabaseReference!
    
    let findResultContactView:UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    
    let activityIndicator:UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.activityIndicatorViewStyle = .whiteLarge
        activity.color = UIColor.blue
        activity.startAnimating()
        return activity
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    let closeButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.addTarget(self, action: #selector(cancelAddContact(_:)), for: .touchUpInside)
        return button
    }()
    
    let findResultLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    let sendButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.isHidden = true
        return button
    }()

    // MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        // layout views
        setupFindResultContact()
        setupActivityIndicatorView()
        setupCloseButton()
        setupSendButton()
        setupFindResultLabel()
        
        ref = Database.database().reference()
    
    }
    // MARK:- Layout views
    private func setupFindResultContact(){
        // layout find result contact view
        view.addSubview(findResultContactView)
        findResultContactView.anchorsLayoutView(top: nil, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, constants: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24), size: CGSize(width: 0, height: 250))
        findResultContactView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        findResultContactView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
    }
    
    private func setupActivityIndicatorView(){
        findResultContactView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: findResultContactView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: findResultContactView.centerYAnchor).isActive = true
    }
    
    private func setupCloseButton(){
        findResultContactView.addSubview(closeButton)
        closeButton.anchorsLayoutView(top: findResultContactView.topAnchor, left: nil, bottom: nil, right: findResultContactView.rightAnchor, constants: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12), size: CGSize(width: 24, height: 24))
        setupProfileImageView()
    }
    
    private func setupProfileImageView(){
        findResultContactView.addSubview(profileImageView)
        profileImageView.anchorsLayoutView(top: closeButton.bottomAnchor, left: nil, bottom: nil, right: nil, constants: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 64, height: 64))
        profileImageView.centerXAnchor.constraint(equalTo: findResultContactView.centerXAnchor).isActive = true
    }
    
    private func setupSendButton(){
        findResultContactView.addSubview(sendButton)
        sendButton.anchorsLayoutView(top: nil, left: findResultContactView.leftAnchor, bottom: findResultContactView.bottomAnchor, right: findResultContactView.rightAnchor, constants: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 64))
    }
    
    private func setupFindResultLabel(){
        findResultContactView.addSubview(findResultLabel)
        findResultLabel.anchorsLayoutView(top: profileImageView.bottomAnchor, left: findResultContactView.leftAnchor, bottom: sendButton.topAnchor, right: findResultContactView.rightAnchor, constants: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24), size: nil)
    }
    
    // MARK:- Private instance methods
    private func showResultView(){
        activityIndicator.isHidden = true
        profileImageView.isHidden = false
        findResultLabel.isHidden = false
        sendButton.isHidden = false
    }
    
    private func fetchUserByEmail(email: String,completeHandle: @escaping (User?) -> ()){
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let childrens = snapshot.children.allObjects as! [DataSnapshot]
            for children in childrens {
                let value = children.value as! [String: Any]
                // get email to compare emailTextField
                let emailResult = value["email"] as! String
                if emailResult == email{
                    let user = User()
                    user.id = children.key
                    user.setValueForKeys(values: value)
                    completeHandle(user)
                    return
                }
            }
            completeHandle(nil)
        })
    }
    
    // MARK:- Actions
    @IBAction func cancelAddContact(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findContactToAdd(_ sender: UIButton) {
        if let email = emailTextField.text {
            emailTextField.resignFirstResponder()
            alertView.isHidden = true
            findResultContactView.isHidden = false
            // invoke fetch user function to check user alrealy exist
            fetchUserByEmail(email: email, completeHandle: { (user) in
                if let user = user {
                    self.showResultView()
                    
                    // hide actitity
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    // display contact find result
                    self.profileImageView.loadImageUsingCacheWithUrl(urlString: user.championUrlImage!)
                    
                    
                }
            })
            
        }
    }
    
    
}
// MARK:- UITextFieldDelegate
extension AddNewContactViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
