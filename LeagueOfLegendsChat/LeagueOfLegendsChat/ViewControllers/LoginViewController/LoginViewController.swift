//
//  LoginViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegate for text fields
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    // MARK:- Actions
    
    @IBAction func handleLogin(_ sender: UIButton) {
        if emailTextField.text == ""{
            presentAlertWithoutAction(title: "", and: "Please enter email")
        }else if passwordTextField.text == ""{
            presentAlertWithoutAction(title: "", and: "Please enter password")
        }else{
            //  if text email is email, it will login
            if !emailTextField.checkTextIsEmail(){
                emailTextField.text = "Wrong email format"
                emailTextField.textColor = UIColor.red
            }else{
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    UserDefaults.standard.setIsLoggedIn(value: true)
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func handleRegisterAccount(_ sender: UIButton) {
        perform(#selector(showRegisterViewControllerToRegisterAcc), with: nil, afterDelay: 0.01)
    }
    
    @objc func showRegisterViewControllerToRegisterAcc(){
        let registerViewController = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.present(registerViewController, animated: true, completion: nil)
    }
    
}

// MAKR:- UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(emailTextField){
            textField.text = ""
            textField.textColor = UIColor.black
        }
    }
    
}

