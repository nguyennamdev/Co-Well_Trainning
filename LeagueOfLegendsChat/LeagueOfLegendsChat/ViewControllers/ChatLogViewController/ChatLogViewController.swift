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
    
    // MARK:- Views
    let inputContainerView:UIView = UIView()
    
    let inputMessageTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Aa"
        return tf
    }()
    
    let sendButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "send-button"), for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = contact?.name
        setupViews()
      
        self.collectionView?.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.backgroundColor = UIColor.white
        
    }
  
    // MARK:- Private instance methods
    private func setupViews(){
        setupInputViewController()
        setupSendButton()
        setupInputMessageTextField()
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
    
    // MARK:- Actions
    @objc private func handleSendMessage(){
        // send message with text
        if let text = inputMessageTextField.text{
            sendMessageWithProperties(properties: ["text": text])
        }
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
}

