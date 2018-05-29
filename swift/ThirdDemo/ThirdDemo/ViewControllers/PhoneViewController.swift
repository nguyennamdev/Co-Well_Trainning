//
//  ViewController.swift
//  ThirdDemo
//
//  Created by Nguyen Nam on 5/15/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class PhoneTableViewController: UITableViewController {
    
    var arrPhone:[Phone] = [Phone]()
    var moneyType:MoneyType?
//    var oldCurrency:Currency = AppDelegate.currentcy
    var oldMoneyType = AppDelegate.moneyType
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init default array
        arrPhone = [
            Phone("Iphone 10", 1000.USD, #imageLiteral(resourceName: "iphonex")),
            Phone("Iphone 8", 800.USD, #imageLiteral(resourceName: "iphone8")),
            Phone("Samsung s9", 900.USD, #imageLiteral(resourceName: "s9"))
        ]
        
        self.moneyType = MoneyType.USD
        self.tableView.rowHeight = 110
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // handle currency of phone price
        var priceOfCurrentCurrency:Int?
        switch AppDelegate.moneyType {
        case .USD:
            priceOfCurrentCurrency = 1.USD
            self.moneyType = MoneyType.USD
        case .VND:
            priceOfCurrentCurrency = 1.VND
            self.moneyType = MoneyType.VND
        case .YEN:
            priceOfCurrentCurrency = 1.YEN
            self.moneyType = MoneyType.YEN
        }

        var oldCurrency:Int
        switch oldMoneyType{
        case .USD:
            oldCurrency = 1.USD
        case .VND:
            oldCurrency = 1.VND
        case .YEN:
            oldCurrency = 1.YEN
        }
        for phone in self.arrPhone {
            // solve price
            // p = usd * nP
            let convertToUSD = phone.price / oldCurrency
            phone.price = convertToUSD * priceOfCurrentCurrency!
        }
        // save oldMoneyType by currentMoneyType
        oldMoneyType = AppDelegate.moneyType
        self.tableView.reloadData()
    }

    // MARK: Actions
    
    @IBAction func addNewPhone(_ sender: UIBarButtonItem) {
        let addPhoneViewController = self.storyboard?.instantiateViewController(withIdentifier: "addPhone") as? AddPhoneViewController
        addPhoneViewController?.delegate = self
        self.navigationController?.pushViewController(addPhoneViewController!, animated: true)
    }
    
}

// MARK: Implement UITableViewController

extension PhoneTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPhone.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as? PhoneTableViewCell
        cell?.phone = self.arrPhone[indexPath.row]
        cell?.priceLabel.text = "\(self.arrPhone[indexPath.row].price.formatedNumberWithUnderDots()) \(self.moneyType?.rawValue ?? "")"
        return cell!
    }

}
// MARK: Implement PhoneDelegate
extension PhoneTableViewController: PhoneDelegate{
    
    func addNewPhone(phone: Phone) {
        self.arrPhone.append(phone)
        self.tableView.reloadData()
    }
    
}


