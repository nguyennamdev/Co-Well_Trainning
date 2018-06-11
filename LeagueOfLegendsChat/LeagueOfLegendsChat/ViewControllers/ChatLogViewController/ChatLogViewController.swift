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
import FirebaseStorage
import Photos

private let cellId = "cellId"

class ChatLogViewController : UICollectionViewController {
    
    // MARK:- Properties
    
    var ref:DatabaseReference!
    var messages:[Message] = [Message]()
    var mediaButtons:[UIButton] = [UIButton]()
    var startingImageFrame:CGRect?
    var blackBackgroundColor:UIView?
    var images:[UIImage] = [UIImage]()
    var stickerImages:[UIImage] = [UIImage]()
    var bubbleColor:UIColor?
    
    var photoLibraryIsShowing:Bool = false{
        didSet{
            chooseImageButton.isSelected = photoLibraryIsShowing ? true : false
        }
    }
    var stickersCollectionIsShowing:Bool = false{
        didSet{
            stickerButton.isSelected = stickersCollectionIsShowing ? true : false
        }
    }

    // constaints
    var bottomConstaintInputContainerView:NSLayoutConstraint?
    var widthConstaintMediaActionsView:NSLayoutConstraint?
    var heightConstaintPhotoLibraryCollectionView:NSLayoutConstraint?
    var heightConstaintStickerCollectionView:NSLayoutConstraint?
    
    var contact:Contact?{
        didSet{
            observeMessages()
            observeBubbleColor()
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
        // padding view
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 35))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        return tf
    }()
    
    lazy var stickerButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: -2, y: 0, width: 24, height: 24)
        button.setImage(#imageLiteral(resourceName: "happiness"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "happy-face"), for: .selected)
        button.contentMode = .center
        button.addTarget(self, action: #selector(showStickersCollectionView), for: .touchUpInside)
        return button
    }()
    
    lazy var sendButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("👍", for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    let mediaActionsView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    let extendButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "right-arrow"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showMediaButtons), for: .touchUpInside)
        return button
    }()
    
    let chooseImageButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "picture"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "picture_selected"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "picture_selected"), for: .selected)
        button.addTarget(self, action: #selector(handleSelectImage), for: .touchUpInside)
        return button
    }()
    
    let captureImageButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(#imageLiteral(resourceName: "photo-camera"), for: .normal)
        button.addTarget(self, action: #selector(captureImageToSendMessageWithImage), for: .touchUpInside)
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
    
    let photosLibraryCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        collectionView.tag = 1
        return collectionView
    }()
    
    let stickersCollectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.tag = 2
        return collectionView
    }()
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // custom back button
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "left-arrow"), style: .plain, target: self, action: #selector(backToRootView))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = contact?.name
        customRightBarButton()
        
        // setup default collectionView
        initChatCollectionView()
        initPhotoLibraryCollectionView()
        initStickersCollectionView()
        
        // init observe when keyboard show or hide
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // init media buttons
        mediaButtons = [captureImageButton, chooseImageButton]
      
        // observe methods
        grabPhotos()
    }
    
    
    // MARK:- Setup Views
    private func customRightBarButton(){
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        button.setImage(#imageLiteral(resourceName: "color"), for: .normal)
        button.addTarget(self, action: #selector(showColorCollection), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func initChatCollectionView(){
        self.collectionView?.tag = 0
        self.collectionView?.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.isUserInteractionEnabled = true
        self.collectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEndEditing)))
    }
    
    private func initPhotoLibraryCollectionView(){
        self.photosLibraryCollectionView.delegate = self
        self.photosLibraryCollectionView.dataSource = self
        self.photosLibraryCollectionView.register(PhotoLibraryCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
    }
    
    private func initStickersCollectionView(){
        self.stickersCollectionView.delegate = self
        self.stickersCollectionView.dataSource = self
        self.stickersCollectionView.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: "stickerCell")
    }
    
    private func setupViewsWithoutContactNotBlock(){
        setupInputViewController()
        setupSendButton()
        setupMediaActionsStackView()
        setupInputMessageTextField()
        setupPhotoLibraryCollection()
        setupStickersCollectionView()
    }
    
    private func setupViewsWithContactBlocked(){
        setupBlockContainerView()
        setupUnblockButton()
        setupBlockTitleLabel()
    }
    
    // MARK:- Observe methods
    private func observeMessages(){
        guard let uid = Auth.auth().currentUser?.uid, let toId = self.contact?.id else { return }
        ref = Database.database().reference().child("user-messages").child(uid).child(toId)
        ref.child("messages").observe(.childAdded) { (snapshot) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let messageId = snapshot.key
            // get message by message references with message id
            self.fetchMessageWithMessageId(messageId: messageId)
        }
    }
    
    private func fetchMessageWithMessageId(messageId:String){
        let messageRef = Database.database().reference().child("messages").child(messageId)
        messageRef.observeSingleEvent(of: .value) { (snapshot) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let dictionary = snapshot.value as? [String: Any]{
                let message = Message(values: dictionary)
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    // scroll to last item
                    let item = self.messages.count - 1
                    let indexPath = IndexPath(item: item, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
                }
            }
        }
    }

    private func observeBubbleColor(){
        guard let uid = Auth.auth().currentUser?.uid, let toId = self.contact?.id else { return }
        let bubbleColorRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        bubbleColorRef.child("bubbleColor").observe(.value) { (snapshot) in
            let hexaString = snapshot.value as? String
            if let hexString = hexaString{
                self.bubbleColor = UIColor(hexString: hexString)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }

    private func observeStickers(){
        let stickerRef = Database.database().reference().child("stickers")
        stickerRef.observeSingleEvent(of: .value) { (snapshot) in
            let childrens = snapshot.children.allObjects as! [DataSnapshot]
            for child in childrens{
                let stickerFolderName = child.key
                let fileNames = child.value as! [String]
                if !self.checkStickerExist(stickerFolderName: stickerFolderName){
                    // sticker didn't save on local file
                    fileNames.forEach({ (fileName) in
                        // download file to local filesystem
                        self.downloadImageToLocalFile(imageName: fileName, stickerFolderName: stickerFolderName)
                    })
                }else{
                    // sticker saved on local file
                    fileNames.forEach({ (fileName) in
                        let imageSaved = self.getStickerSavedInLocal(by: stickerFolderName, imageName: fileName)
                        if let image = imageSaved{
                            self.stickerImages.append(image)
                            // reload data
                            DispatchQueue.main.async {
                                self.stickersCollectionView.reloadData()
                            }
                        }
                    })
                }
            }
        }
    }
    
    // MARK:- Private instance methods
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
    
    private func grabPhotos(){
        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult : PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if fetchResult.count > 0{
            for i in 0..<fetchResult.count{
                imageManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, any) in
                    self.images.append(image!)
                })
            }
        }
        photosLibraryCollectionView.reloadData()
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
                // get message id key
                let messageId = refer.key
            
                let userMessageRef = Database.database().reference().child("user-messages").child(currentId).child(toContactId)
                userMessageRef.child("messages").updateChildValues([messageId:1])
                
                // at the same time recipent contact message ref
                let recipentContactRef = Database.database().reference().child("user-messages").child(toContactId).child(currentId)
                recipentContactRef.child("messages").updateChildValues([messageId:1])
            })
        }
    }
    
    func sendMessageWithUploadImage(imageUrl: String, image:UIImage){
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let values = ["imageUrl": imageUrl, "imageWidth": imageWidth, "imageHeight": imageHeight] as [String: Any]
        sendMessageWithProperties(properties: values)
    }
    
    func sendMessageWithSticker(stickerUrl: String, stickerImage:UIImage){
        let imageWidth = stickerImage.size.width
        let imageHeight = stickerImage.size.height
        let values = ["stickerUrl": stickerUrl, "imageWidth": imageWidth, "imageHeight": imageHeight] as [String: Any]
        sendMessageWithProperties(properties: values)
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
    
    private func checkStickerExist(stickerFolderName:String) -> Bool{
        // func return true if stickerFolderName exist
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let directory = paths[0]
        let fileManager = FileManager.default
        
        let url = URL(fileURLWithPath: directory).appendingPathComponent("stickers/\(stickerFolderName)")
    
        if !fileManager.fileExists(atPath: url.path){
            return false
        }
        return true
    }
    
    private func downloadImageToLocalFile(imageName:String, stickerFolderName:String){
        let stickersStoreRef = Storage.storage().reference().child("stickers").child(stickerFolderName).child(imageName)
        
        // get document url
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let localUrl = documentsUrl.appendingPathComponent("stickers/\(stickerFolderName)/\(imageName)")
        // dowload to the local filesystem
        stickersStoreRef.write(toFile: localUrl) { (url, error) in
            if error != nil{
                print(error!)
                return
            }
            // load image saved that
            let imageSaved = UIImage(contentsOfFile: localUrl.path)
            if let image = imageSaved{
                self.stickerImages.append(image)
                // reload data
                DispatchQueue.main.async {
                    self.stickersCollectionView.reloadData()
                }
            }
        }
    }
    
    private func getStickerSavedInLocal(by stickerFolderName:String, imageName:String) -> UIImage?{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let directory = paths.first!
        let imageUrl = URL(fileURLWithPath: directory).appendingPathComponent("stickers/\(stickerFolderName)/\(imageName)")
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image
    }
    
    
    
    // MARK:- Actions
    @objc private func backToRootView(){
        self.navigationController?.popViewController(animated: true)
    }
    
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
                    }else{
                        self.sendMessageWithProperties(properties: ["text" : self.inputMessageTextField.text!])
                    }
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
    
    @objc private func handleKeyboardNotification(notification:Notification){
        if let userInfo = notification.userInfo{
            // get keyboard frame
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            let isKeyboardShowing = notification.name == Notification.Name.UIKeyboardWillShow
            // change contant bottom of input container view
            bottomConstaintInputContainerView?.constant = isKeyboardShowing ? -(keyboardFrame.height - 49): 0
            // hide photoLibraryCollection
            heightConstaintPhotoLibraryCollectionView?.constant = 0
            // change state of choose button
            chooseImageButton.isSelected = false
            
            self.tabBarController?.tabBar.isHidden = false
            // scroll to last message
            if messages.count > 0{
                 self.collectionView?.scrollToItem(at: IndexPath(item: self.messages.count - 1, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
            }
            // animate
            UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func captureImageToSendMessageWithImage(){
        // hide keyboard
        inputMessageTextField.resignFirstResponder()
        
        // init imagePickerView open camera to capture image
        let imagePickerView = UIImagePickerController()
        imagePickerView.sourceType = .camera
        imagePickerView.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
        imagePickerView.cameraFlashMode = .off
        imagePickerView.delegate = self
        present(imagePickerView, animated: true, completion: nil)
    }
    
    private func animate(){
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    
    @objc private func handleSelectImage(){
        photoLibraryIsShowing = !photoLibraryIsShowing
        stickersCollectionIsShowing = false
        // hide keyboard
        inputMessageTextField.resignFirstResponder()
        // move inputContainerView to above photoLibraryCollection
        bottomConstaintInputContainerView?.constant = photoLibraryIsShowing ? -151 : 0
        // show or hide LibraryColleciton
        heightConstaintPhotoLibraryCollectionView?.constant = photoLibraryIsShowing ? 200 : 0
        // show or hide StickersCollection
        heightConstaintStickerCollectionView?.constant = 0
        // hide tabbar
        self.tabBarController?.tabBar.isHidden = photoLibraryIsShowing ? true : false
        animate()
    }
    
    @objc private func showStickersCollectionView(sender:UIButton){
        observeStickers()
        stickersCollectionIsShowing = !stickersCollectionIsShowing
        photoLibraryIsShowing = false
        // hide keyboard
        inputMessageTextField.resignFirstResponder()
        // show stickersCollectionView and hide tabbar
        heightConstaintStickerCollectionView?.constant = stickersCollectionIsShowing ? 200 : 0
        bottomConstaintInputContainerView?.constant = stickersCollectionIsShowing ? -151 : 0
        heightConstaintPhotoLibraryCollectionView?.constant = 0
        self.tabBarController?.tabBar.isHidden = stickersCollectionIsShowing ? true : false
        animate()
    }
    
    @objc private func handleEndEditing(){
        self.photoLibraryIsShowing = false
        self.stickersCollectionIsShowing = false
        self.tabBarController?.tabBar.isHidden = false
        heightConstaintStickerCollectionView?.constant = 0
        heightConstaintPhotoLibraryCollectionView?.constant = 0
        bottomConstaintInputContainerView?.constant = 0
        animate()
        self.view.endEditing(true)
    }

    private func changeBubbleColor(colorHex:String){
        if let uid = Auth.auth().currentUser?.uid, let contactId = self.contact?.id {
            let bubbleColorRef = Database.database().reference().child("user-messages").child(uid).child(contactId)
            bubbleColorRef.child("bubbleColor").setValue(colorHex)
            self.bubbleColor = UIColor(hexString: colorHex)
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    @objc private func showColorCollection(){
        let colorChatViewController = ColorChatViewController(nibName: "ColorChatViewController", bundle: nil)
        colorChatViewController.modalPresentationStyle = .overFullScreen
        // it will execute when user selected color
        colorChatViewController.selectedColorClosure = { (color) in
            self.changeBubbleColor(colorHex: color.toHexString())
        }
        present(colorChatViewController, animated: true, completion: nil)
    }
    
}

// MARK:- UITextFieldDelegate
extension ChatLogViewController : UITextFieldDelegate {
    
    @objc fileprivate func showMediaButtons(){
        // make width of stack widen
        widthConstaintMediaActionsView?.constant = 56
        // remove existing buttons
        mediaActionsView.removeArrangedSubview(extendButton)
        extendButton.removeFromSuperview()
        // add new buttons
        for button in mediaButtons{
            mediaActionsView.addArrangedSubview(button)
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func hideMediaButtons(){
        // make width of stack smaller
        widthConstaintMediaActionsView?.constant = 24
        
        // remove existing buttons
        for button in mediaButtons{
            mediaActionsView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        mediaActionsView.addArrangedSubview(extendButton)
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.handleEndEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        showMediaButtons()
        
        // change image and title for button send
        if textField.text != ""{
            self.sendButton.setTitle("", for: .normal)
            self.sendButton.setImage(#imageLiteral(resourceName: "send-button"), for: .normal)
        }else{
            self.sendButton.setTitle("👍", for: .normal)
            self.sendButton.setImage(nil, for: .normal)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.photoLibraryIsShowing = false
        self.stickersCollectionIsShowing = false
        self.sendButton.setTitle("", for: .normal)
        self.sendButton.setImage(#imageLiteral(resourceName: "send-button"), for: .normal)
        hideMediaButtons()
    }
}

// MARK:- UIImagePickerControllerDelegate

extension ChatLogViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        handleEndEditing()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        handleImageSelectedForInfo(info: info)
        handleEndEditing()
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleImageSelectedForInfo(info:[String:Any]){
        if let imageOriginal = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let imageCapture = imageOriginal
            // handle update image to firebase
            updateFileToFirebaseUsingImage(image: imageCapture, quantityImage: 0.1, completion: { (imageUrl) in
                // call func sendMessageWithImage to send message
                self.sendMessageWithUploadImage(imageUrl: imageUrl, image: imageCapture)
            })
        }
    }
    
    func updateFileToFirebaseUsingImage(image:UIImage, quantityImage: CGFloat, completion: @escaping (_ imageUrl:String) -> ()){
        let imageName = NSUUID().uuidString
        let storeRef = Storage.storage().reference().child("message_images").child(imageName)
        // get data of image
        if let uploadData = UIImageJPEGRepresentation(image, quantityImage){
            storeRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                // upload completed then get imageUrl
                if let imageUrl = metadata?.downloadURL()?.absoluteString{
                    completion(imageUrl)
                }
            })
        }
    }
}

// MARK:- ChatMessageDelegate
extension ChatLogViewController : ChatMessageDelegate {
    
    func selectedImageFromPhotoLibrary(image: UIImage) {
        // invoke func sendMessageWithImage to send this image
        self.updateFileToFirebaseUsingImage(image: image, quantityImage: 0.7) { (imageUrl) in
            self.sendMessageWithUploadImage(imageUrl: imageUrl, image: image)
        }
    }
    
    func performZoomInForStartingImageView(image: UIImageView) {
        // get frame original of image selected
        self.startingImageFrame = image.superview?.convert(image.frame, to: nil)
        
        // configuration zooming image view
        let zoomingImageView = UIImageView(frame: startingImageFrame!)
        zoomingImageView.image = image.image
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(sender:)))) // add action zoom out
        zoomingImageView.isUserInteractionEnabled = true
        
        if let keyWindow = UIApplication.shared.keyWindow{
            self.blackBackgroundColor = UIView(frame: keyWindow.frame)
            self.blackBackgroundColor?.backgroundColor = UIColor.black
            self.blackBackgroundColor?.alpha = 0
            keyWindow.addSubview(blackBackgroundColor!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.blackBackgroundColor?.alpha = 1
                
                let imageViewHeight = (self.startingImageFrame?.height)! / (self.startingImageFrame?.width)! * keyWindow.frame.width
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: imageViewHeight)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(sender:UITapGestureRecognizer){
        if let zoomOutImageView = sender.view{
            // need animate to back out to view controller
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingImageFrame!
                self.blackBackgroundColor?.alpha = 0
                self.blackBackgroundColor = nil
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
            })
        }
    }
}


