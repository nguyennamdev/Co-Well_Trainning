//
//  CustomTabbarViewController.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class CustomTabbarViewController: UITabBarController {
    
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // if user is logged in, it will display this tabbar view controler
        // if user isn't logged in, it will show loginViewController to login
        if !isLoggedIn(){
            perform(#selector(showLoginViewController), with: nil, afterDelay: 0.01)
        }

    }
    
    // MARK: Actions
    @objc func showLoginViewController(){
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        present(loginViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private instance methods
    private func isLoggedIn() -> Bool {
        return UserDefaults.standard.getIsLoggedIn()
    }
    
}
