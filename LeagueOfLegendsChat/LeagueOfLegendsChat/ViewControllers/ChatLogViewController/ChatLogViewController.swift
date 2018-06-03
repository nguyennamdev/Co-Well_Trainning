//
//  ChatLogViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 6/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

private let cellId = "cellId"

class ChatLogViewController : UICollectionViewController {
    
    // MARK:- Properties
    var bottomConstaintInputContainerView:NSLayoutConstraint?
    var ref:DatabaseReference!
    var messages:[Message] = [Message]()
    
    var contact:Contact?{
        didSet{
            observeMessages()
        }
    }
    var currentUser:User?{
        didSet{
            if checkWhetherContactIsBlocked(by: self.currentUser!){
              // contact blocked
              // don't allow to send message
                setupViewsWithContactBlocked()
            }else{
                setupViewsWithoutContactNotBlock()
            }
        }
    }
    
    // MARK:- Views
    let inputContainerView:UIView = UIView()
    
    let inputMessageTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Aa"
        return tf
    }()
    
    let sendButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("👍", for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    let blockContainerView:UIView = UIView()
    let blockTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "You have been block this contact".localized
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    let unblockButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Unblock".localized, for: .normal)
        button.tintColor = UIColor.green
        button.addTarget(self, action: #selector(handleUnblockContact), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = contact?.name

        self.collectionView?.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.backgroundColor = UIColor.white
    }
  
    // MARK:- Private instance methods
    private func setupViewsWithoutContactNotBlock(){
        setupInputViewController()
        setupSendButton()
        setupInputMessageTextField()
    }
    
    private func setupViewsWithContactBlocked(){
        setupBlockContainerView()
        setupUnblockButton()
        setupBlockTitleLabel()
    }
    
    private func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid, let toId = self.contact?.id else { return }
        ref = Database.database().reference().child("user-messages").child(uid).child(toId)
        ref.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            // get message by message references with message id
            self.fetchMessagesWithMessageId(messageId: messageId)
        }
    }
    
    private func fetchMessagesWithMessageId(messageId:String){
        let messageRef = Database.database().reference().child("messages").child(messageId)
        messageRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                let message = Message()
                message.setValueForKeys(values: dictionary)
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    // scroll to last item
                    let item = self.messages.count - 1
                    let indexPath = IndexPath(item: item, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    private func checkWhetherContactIsBlocked(by currentUser:User) -> Bool{
        if let contactId = self.contact?.id{
            if let contactsBlocked =  currentUser.listBlocked{
                // if contact id in list blocked of current user func will return true
                for contactBlocked in contactsBlocked{
                    if contactId == contactBlocked{
                        // contact in list blocked
                        return true
                    }
                }
            }
        }
        return false
    }

    private func checkWhetherCurrentUserIsBlocked(by contact:Contact, completeHandle:@escaping (Bool) -> ()){
        if let currentId = Auth.auth().currentUser?.uid, let contactId = contact.id{
            // if current id in list blocked of contact, function will return true
            let contactsBlockedRef = Database.database().reference().child("users").child(contactId)
            contactsBlockedRef.child(Define.CONTACTS_BLOCKED).observeSingleEvent(of: .value, with: { (snapshot) in
                let childrens = snapshot.children.allObjects as? [DataSnapshot]
                if let childrens = childrens{
                    for child in childrens{
                        if child.value as! String == currentId{
                            // current id blocked by that contact
                            completeHandle(true)
                            return
                        }
                    }
                }
                completeHandle(false)
            })
        }
    }
    
    private func sendMessageWithProperties(properties:[String: Any]){
        if let currentId = Auth.auth().currentUser?.uid, let toContactId = self.contact?.id{
            let timestamp:Int = Int(NSDate().timeIntervalSince1970)
            var values = [Define.TO_ID: toContactId, Define.FROM_ID: currentId, "timestamp": timestamp] as [String : Any]
            // append to properties dictionary value
            properties.forEach({ (key,value) in
                values[key] = value
            })
            let addNewMessageRef =  Database.database().reference().child("messages").childByAutoId()
            addNewMessageRef.updateChildValues(values, withCompletionBlock: { (error, refer) in
                if error != nil{
                    print(error!)
                    return
                }
                self.inputMessageTextField.text = nil
                let messageId = refer.key
                
                let userMessageRef = Database.database().reference().child("user-messages").child(currentId).child(toContactId)
                userMessageRef.updateChildValues([messageId:1])
                
                // at the same time recipent contact message ref
                let recipentContactRef = Database.database().reference().child("user-messages").child(toContactId).child(currentId)
                recipentContactRef.updateChildValues([messageId:1])
            })
        }
    }
    
    private func getKeyContactUnblock(fromId: String, toId: String, completeHandle:@escaping (_ key:String?) -> ()){
        // remove contact in list blocked of current user
        Database.database().reference().child("users").child(fromId).child(Define.CONTACTS_BLOCKED).observe(.value) { (snapshot) in
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
    
    // MARK:- Actions
    @objc private func handleSendMessage(){
        if let contact = self.contact{
            // call method checkWhetherCurrentUserIsBlocked to check
            checkWhetherCurrentUserIsBlocked(by: contact, completeHandle: { (isBlocked) in
                if isBlocked{
                    // current user blocked by that contact, so don't allow to send message
                    self.presentAlertWithoutAction(title: "Sorry".localized, and: "You have been blocked by this contact".localized, completion: nil)
                }else{
                    // current user don't block by that contact, so allows to send message
                    if self.inputMessageTextField.text == ""{
                        // if message text = empty, it will send emoji
                        self.sendMessageWithProperties(properties: ["text" : "👍"])
                    }
                    self.sendMessageWithProperties(properties: ["text" : self.inputMessageTextField.text!])
                }
            })
        }
    }
    
    @objc private func handleUnblockContact(){
        if let currentId = self.currentUser?.id, let contactId = self.contact?.id {
            getKeyContactUnblock(fromId: currentId, toId: contactId, completeHandle: { (key) in
                if let key = key{
                    // begin remove contact id in list blocked of current user
                    let removeRef = Database.database().reference().child("users").child(currentId).child(Define.CONTACTS_BLOCKED)
                    removeRef.child(key).removeValue(completionBlock: { (error, refer) in
                        if error != nil{
                            print(error!)
                            return
                        }
                        // hide block container view
                        self.blockContainerView.isHidden = true
                        self.setupViewsWithoutContactNotBlock()
                    })
                }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK:- UICollectionViewDataSource
extension ChatLogViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ChatMessageCollectionViewCell
        cell?.message = self.messages[indexPath.row]
        cell?.contact = self.contact
        return cell!
    }
}
// MARK:- UICollectionViewDelegateFlowLayout
extension ChatLogViewController : UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 80
        if let text = self.messages[indexPath.row].text{
            // get estimate height of text
            let frameText = text.estimateFrameOfString()
            height = frameText.height + 20
        }else{
            // solve height without text
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
    
}

// MARK:- UITextFieldDelegate
extension ChatLogViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // change image and title for button send
        if textField.text != ""{
            self.sendButton.setTitle("", for: .normal)
            self.sendButton.setImage(#imageLiteral(resourceName: "send-button"), for: .normal)
        }else{
            self.sendButton.setTitle("👍", for: .normal)
            self.sendButton.setImage(nil, for: .normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location > 0{
            self.sendButton.setTitle("", for: .normal)
            self.sendButton.setImage(#imageLiteral(resourceName: "send-button"), for: .normal)
        }else{
            self.sendButton.setTitle("👍", for: .normal)
            self.sendButton.setImage(nil, for: .normal)
        }
        return true
    }
    
    
}

