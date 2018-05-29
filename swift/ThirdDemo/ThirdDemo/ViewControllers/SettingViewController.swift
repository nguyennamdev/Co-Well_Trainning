//
//  SettingViewController.swift
//  ThirdDemo
//
//  Created by Nguyen Nam on 5/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    // MARK: Views
    @IBOutlet weak var moneyTypeSegment: UISegmentedControl!
    
    // MARK: Properties
    let arrMoneyType = MoneyType.allValues
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove all element in segment
        moneyTypeSegment.removeAllSegments()
        // add new element for segment by arrMoneyType
        for (index,item) in arrMoneyType.enumerated() {
            moneyTypeSegment.insertSegment(withTitle: item.rawValue, at: index, animated: true)
        }
    }
    

    @IBAction func moneyTypeValueChanged(_ sender: UISegmentedControl) {
        let indexOfSeletedSegment:Int = sender.selectedSegmentIndex
        let moneyType = self.arrMoneyType[indexOfSeletedSegment]
         // change currentcy with index selected
        switch moneyType {
        case .USD:
            AppDelegate.moneyType = MoneyType.USD
//            AppDelegate.currentcy = Currency.USD
        case .VND:
            AppDelegate.moneyType = MoneyType.VND
//            AppDelegate.currentcy = Currency.VND
        case .YEN:
            AppDelegate.moneyType = MoneyType.YEN
//            AppDelegate.currentcy = Currency.YEN
        }
        self.tabBarController?.selectedIndex = 0
        
    }
    
}
