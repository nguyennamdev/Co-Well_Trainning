//
//  AddPhoneViewController.swift
//  ThirdDemo
//
//  Created by Nguyen Nam on 5/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class AddPhoneViewController: UIViewController {
    
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var phoneNameTextField: UITextField!
    
    
    var delegate:PhoneDelegate?
    var phone:Phone?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // custom right bar button item
        let rightBarButtonItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(handleAddNewPhone))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK: Actions
    
    @objc private func handleAddNewPhonse(){
        guard let phoneName = phoneNameTextField.text,
            let price = priceTextField.text else {
            return
        }
        if phone == nil{
            phone = Phone()
        }
        phone?.name = phoneName
        phone?.price = Int(price)!.USD
        delegate?.addNewPhone(phone: phone!)
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
