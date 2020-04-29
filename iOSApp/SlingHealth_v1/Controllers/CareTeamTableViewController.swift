//
//  CareTeamTableViewController.swift
//  SlingHealth_v1
//
//  Created by Faith Letzkus on 3/8/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CareTeamTableViewController: UITableViewController {

    let db = Firestore.firestore()
    // lazy var medications = db.collection("medication").document(Auth.auth().currentUser!.uid).collection("user_meds")
    var teams =  [CareTeam]()
   
//    var oldMedications = [Medication]()
    
    var selectedTeam : CareTeam?

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        loadData()
    }
    
    func loadData() {
        // Adding medication names to the string array
        db.collection("teams").document(Auth.auth().currentUser!.uid)
          .collection("user_teams").getDocuments()
          { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.teams = []
                    
                    for document in querySnapshot!.documents {
                        print(document)
                        print(document.get("physician") ?? "hi")
                        let newTeam = CareTeam(id: -1, physician: document.get("physician") as? String,
                                                specialty: document.get("specialty") as? String,
                                                physicianNumber: document.get("physicianNumber") as? Int,
                                                nurse: document.get("nurse") as? String,
                                                caretaker: document.get("caretaker") as? String,
                                                caretakerNumber: document.get("caretakerNumber") as? Int)
                        self.teams.append(newTeam)
                        
                        print("teams here: \(self.teams)")
                        print("newTeam \(newTeam)")
                    }
                    self.teams.sort(by: >)
                    print("right before tableView.reloadData in loadData")
                    self.tableView.reloadData()
                    print("right after tableView.reloadData in loadData")
                }
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("made it here1")
        loadData()
        setUp()
        print("made it here2")
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setUp() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "teamCell")
    }
    
    // define what shows up in each cell here
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("in create cells")
        let myCell = UITableViewCell(style: .subtitle, reuseIdentifier: "teamCell")
        let team = teams[indexPath.row]

        myCell.textLabel!.text = team.physician
        
        if let specialty = team.specialty {
            myCell.detailTextLabel!.text = specialty
        }
        myCell.detailTextLabel?.numberOfLines=0 // line wrap
        myCell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping

        //cell styline
        myCell.clipsToBounds = true
        let myView = UIView(frame: CGRect(x: 10, y: 5, width: 393, height: 67))
        myView.backgroundColor = UIColor.red
        myView.layer.masksToBounds = false
        myView.layer.cornerRadius = 5
        myView.layer.shadowColor = UIColor.lightGray.cgColor
        myView.layer.shadowOpacity = 1
        myView.layer.shadowOffset = CGSize(width: 1, height: 2)
        myView.layer.shadowRadius = 2
        myCell.addSubview(myView)
        myCell.sendSubviewToBack(myView)

        return myCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;//Choose your custom row height
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // define number of rows here
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    
    // define what to do on clicking an item here (most likely detailed view segue)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("in did select row")
        selectedTeam = teams[indexPath.row]
        self.performSegue(withIdentifier: "teamDetailedSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailedCareTeamsTableViewController {
            vc.team = selectedTeam
        }

    }

    // MARK: - Table view data source

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


}
