//
//  ViewController.swift
//  FirstDemo
//
//  Created by Nguyen Nam on 5/9/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var arrAnimal:[Animal]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrAnimal = [
            Animal(name: "Dog 🐶", legs: 4, color: UIColor.blue),
            Animal(name: "Cat 🐱", legs: 4, color: UIColor.brown),
            Animal(name: "Mouse 🐭", legs: 4, color: UIColor.cyan),
            Animal(name: "Rabit 🐹", legs: 4, color: UIColor.green)
        ]
        // set edit button on left
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    // MARK: Actions
    @IBAction func addNewAnimal(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "Add new animal", preferredStyle: .alert)
        // add text fields
        alert.addTextField { (textField) in
            textField.placeholder = "name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "leg"
            textField.keyboardType = .numberPad
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            // unwrap name and leg on text fields
            guard let name =  alert.textFields?[0].text,
                let leg = alert.textFields?[1].text else { return }
            // add animal
            self.arrAnimal?.append(Animal(name: name, legs: Int(leg)!, color: UIColor.white))
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    

    
}

// MARK: TableViewDatasource and TableViewDelegate
extension TableViewController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAnimal?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
        let animal = self.arrAnimal?[indexPath.row]
        cell?.textLabel?.text = animal?.name
        cell?.detailTextLabel?.text = "Legs :\(animal?.legs ?? 0)"
        cell?.backgroundColor = animal?.color
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            self.arrAnimal?.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let name = self.arrAnimal?[indexPath.row].name else { return }
        let alert = UIAlertController(title: "Edit", message: "Edit \(name)", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "leg"
            textField.keyboardType = .numberPad
        }
        let addAction = UIAlertAction(title: "Change", style: .default) { (action) in
            // unwrap name and leg on text fields
            guard let name =  alert.textFields?[0].text,
                let leg = alert.textFields?[1].text else { return }
            // edit animal
            self.arrAnimal?[indexPath.row].name = name
            self.arrAnimal?[indexPath.row].legs = Int(leg)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}












