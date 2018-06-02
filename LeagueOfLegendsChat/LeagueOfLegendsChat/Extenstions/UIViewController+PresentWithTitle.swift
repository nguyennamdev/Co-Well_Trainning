//
//  UIViewController+PresentWithTitle.swift
//  LeagueOfLegendsChat
//
//  Created by Nguyen Nam on 5/28/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertWithoutAction(title: String, and message: String,completion:(() -> Void)?){
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: completion)
    }
    
}
