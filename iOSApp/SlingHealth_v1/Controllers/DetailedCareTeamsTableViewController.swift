//
//  DetailedCareTeamsTableViewController.swift
//  SlingHealth_v1
//
//  Created by Faith Letzkus on 3/8/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit

class DetailedCareTeamsTableViewController: UITableViewController {
    
    //Need to complete this file
    
    public var team: CareTeam!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
     }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return getSectionHeader(index: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if team != nil {
            cell.textLabel!.text = getTeamVal(index: indexPath.section)
        }
        return cell
    }
    
    func getTeamVal(index : Int) -> String {
        guard let t = team else {
            return ""
        }
        switch(index) {
        case 0: return t.physician
        case 1:
            guard let num = t.physicianNumber else {return ""}
            return String(num)
        case 2:
            return t.specialty
        case 3:
            guard let n = t.nurse else {return ""}
            return n
        case 4:
            guard let care = t.caretaker else {return ""}
            return care
        case 5:
            guard let careNum = t.caretakerNumber else {return ""}
            return String(careNum)
        default: return ""
        }
    }
    
    func getSectionHeader(index : Int) -> String {
        switch(index) {
        case 0: return "Physician"
        case 1: return "Specialty"
        case 2: return "Physician's Number"
        case 3: return "Nurse"
        case 4: return "Caretaker"
        case 5: return "Caretaker's Number"
        default: return ""
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let vc = segue.destination as? FormCareTeamsViewController {
               vc.careTeam = team
           }

       }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
