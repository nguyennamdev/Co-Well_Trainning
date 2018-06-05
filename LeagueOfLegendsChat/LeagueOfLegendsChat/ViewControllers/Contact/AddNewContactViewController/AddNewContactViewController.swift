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
    var contactIdWillChat:String?
    var currentUser:User?
    var contactResult:Contact?
    var unwindWithContactIsAlready: ((Contact) -> ())?
    
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
    
    lazy var sendButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.isHidden = true
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSendMessage(sender:)), for: .touchUpInside)
        button.tag = 0
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
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        profileImageView.isHidden = false
        findResultLabel.isHidden = false
        sendButton.isHidden = false
    }
    
    private func fetchContactByEmail(email: String,completeHandle: @escaping (Contact?) -> ()){
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let childrens = snapshot.children.allObjects as! [DataSnapshot]
            for children in childrens {
                let value = children.value as! [String: Any]
                // get email to compare emailTextField
                let emailResult = value["email"] as! String
                if emailResult == email{
                    let contact = Contact()
                    contact.id = children.key
                    contact.setValueForKeys(dict: value)
                    completeHandle(contact)
                    return
                }
            }
            completeHandle(nil)
        })
    }
    
    private func checkContactIsAlready(contactIdResult:String) -> Bool{
        // if contact isn's already exist, it will send request to chat
        // if contact is already exist, it will send message
        if let contactsOfCurrentUser = currentUser?.contacts{
            for contact in contactsOfCurrentUser{
                if contact == contactIdResult{
                    return true
                }
            }
        }
        return false
    }
    
    private func displayFindResultView(){
        emailTextField.resignFirstResponder()
        alertView.isHidden = true
        findResultContactView.isHidden = false
    }
    
    // MARK:- Actions
    @IBAction func cancelAddContact(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSendMessage(sender:UIButton){
        if sender.tag == 1{
            // contact is already exist, so to push chat log
            if let contact = self.contactResult{
                unwindWithContactIsAlready!(contact)
                dismiss(animated: true, completion: nil)
            }
            
        }else{
            if let contactWillSendRequest = self.contactIdWillChat{
                guard let myUid = Auth.auth().currentUser?.uid, let contactName = self.contactResult?.name else { return }
                let contactRequestRef =  Database.database().reference().child("users").child(contactWillSendRequest).child(Define.CONTACT_REQUEST)
                contactRequestRef.childByAutoId().setValue(myUid)
                self.presentAlertWithoutAction(title: "Success".localized, and: "Your request send to".localized + " \(contactName)", completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func findContactToAdd(_ sender: UIButton) {
        if emailTextField.checkTextIsEmail() {
            displayFindResultView()
            // invoke fetch user function to check user alrealy exist
            fetchContactByEmail(email: emailTextField.text!, completeHandle: { (contact) in
                if let contact = contact {
                    // assign contact id to contactIdWillChat
                    self.contactIdWillChat = contact.id
                    self.contactResult = contact
                    // init attritudeString for findResultLabel
                    let attritudeString = NSMutableAttributedString(string: contact.name, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
                    let subAttritudeString:NSAttributedString!
                    var buttonTitle:String = "Send request to chat".localized
                    
                    if self.checkContactIsAlready(contactIdResult: contact.id){
                        // contact is already exist, change button title and attritudeText
                        subAttritudeString = NSAttributedString(string: " is already in your contacts on app".localized, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)])
                        buttonTitle = "Send a message".localized
                        // set tag for sendButton, because do other task if contact is already exist
                        self.sendButton.tag = 1
                    }else{
                        subAttritudeString = NSAttributedString(string: " isn't already in your contacts on app".localized, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)])
                    }
                    attritudeString.append(subAttritudeString)
                    // display contact find result
                    self.showResultView()
                    self.profileImageView.loadImageUsingCacheWithUrl(urlString: contact.championUrlImage!)
                    self.findResultLabel.attributedText = attritudeString
                    self.sendButton.setTitle(buttonTitle, for: .normal)
                }else{
                    // can not found contact
                    self.showResultView()
                    self.profileImageView.image = #imageLiteral(resourceName: "jayce_cry")
                    self.sendButton.isEnabled = false
                    self.findResultLabel.text = "Can not found contact".localized
                }
            })
        }else{
            presentAlertWithoutAction(title: "Sorry".localized, and: "Wrong email format".localized, completion: nil)
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
