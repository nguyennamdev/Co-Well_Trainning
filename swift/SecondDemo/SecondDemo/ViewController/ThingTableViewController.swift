//
//  ThingTableViewController.swift
//  SecondDemo
//
//  Created by Nguyen Nam on 5/11/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class ThingTableViewController: UITableViewController {
    
    var arrayTable:[Table] = [Table]()
    var arraySeat:[Seat] = [Seat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init array Seat
        self.arraySeat = [
            Seat(2, UIColor.purple, 2),
            Seat(1, UIColor.gray, 2),
            Seat(5, UIColor.cyan, 2),
            Seat(3, UIColor.brown, 1),
            Seat(4, UIColor.purple, 1)
        ]
        
        // init arrayTable
        arrayTable = [
            Table(1, UIColor.green, TableType.circle, 1, self.arraySeat[0]),
            Table(2, UIColor.blue, TableType.rectangle, 4, self.arraySeat[1]),
            Table(3, UIColor.orange, TableType.square, 4, self.arraySeat[2]),
            Table(4, UIColor.yellow, TableType.rectangle, 2, self.arraySeat[3]),
            Table(5, UIColor.gray, TableType.circle, 2, self.arraySeat[4])
        ]
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTable.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let table = self.arrayTable[indexPath.row]
        cell.textLabel?.text = "Table: \(table.number), type:\(table.tableType), legs: \(table.tableLegs)"
        if let seat = table.seat{
            cell.detailTextLabel?.text = "Seat: \(seat.number), legs: \(seat.seatLegs)"
        }
        cell.backgroundColor = table.color
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableDidSelected = self.arrayTable[indexPath.row]
        let alert = UIAlertController(title: "Edit seat", message:" Change seat you want" , preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Number of seat"
            textField.keyboardType = .numberPad
        }
        let changeAction = UIAlertAction(title: "Change", style: .default) { (action) in
            let seatNumber = Int((alert.textFields?.first?.text)!)
            if seatNumber != tableDidSelected.seat?.number {
                var tableWillChange:Table?
                var seatWillChange:Seat?
                for t in self.arrayTable{
                    if  t.seat?.number == seatNumber {
                        seatWillChange = t.seat
                        tableWillChange = t
                        tableDidSelected.switchSeat(newSeat: seatWillChange, to: tableWillChange!)
                        break
                    }
                }
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(changeAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: {
            self.tableView.reloadData()
        })
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
