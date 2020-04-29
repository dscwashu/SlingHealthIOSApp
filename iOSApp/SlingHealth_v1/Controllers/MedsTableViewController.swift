//
//  MedsTableViewController.swift
//  SlingHealth_v1
//
//  Created by Faith Letzkus on 1/19/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MedsTableViewController: UITableViewController {

    let db = Firestore.firestore()
    // lazy var medications = db.collection("medication").document(Auth.auth().currentUser!.uid).collection("user_meds")
    var medications =  [Int : [Medication]]()
    let CURRENT = 0;
    let DISCONTINUED = 1;
   
//    var oldMedications = [Medication]()
    
    var selectedMed : Medication?

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        loadData()
    }
    
    func loadData() {
        // Adding medication names to the string array
        db.collection("medication").document(Auth.auth().currentUser!.uid)
          .collection("user_meds").getDocuments()
          { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.medications = [:]
                    self.medications[self.CURRENT] = [] //must initalize the arrays
                    self.medications[self.DISCONTINUED] = []
//                    self.currentMedications = []
//                    self.oldMedications = []
                    for document in querySnapshot!.documents {
                        //FIXME
                        //document.get("startDate") as? Date returns nil b/c document.get("startDate") is a timestamp, must convert back to date
//                        let timestamp = document.get("startDate")
//                        print("timestamp \(timestamp)")
//                        let converted = NSDate(timeIntervalSince1970: timestamp / 1000)
//                        print("startDate \(converted)")
                        let newMed = Medication(id: -1, name: document.documentID,
                                                dose: document.get("dose") as? String,
                                                startDate: (document.get("startDate") as? Timestamp)?.dateValue(),
                                                frequency: document.get("frequency") as? String,
                                                prescriber: document.get("prescriber") as? String,
                                                notes: document.get("notes") as? String,
                                                stillTaking: document.get("stillTaking") as? Bool, reminder: document.get("reminder") as? Bool)
                        if newMed.stillTaking != nil {
                            if newMed.stillTaking {
                                self.medications[self.CURRENT]?.append(newMed)
                            }
                            else {
                                self.medications[self.DISCONTINUED]?.append(newMed)
                            }
                            
                        }
                        else {
                            self.medications[self.CURRENT]?.append(newMed)
                        }
                        
                        print("medications here: \(self.medications)")
//                        self.medications.append(newMed)
//                        if(newMed.stillTaking) {
//                            self.currentMedications.append(newMed)
//                        }
//                        else {
//                            self.oldMedications.append(newMed)
//                        }
//                        print(document.documentID)
                        print("newMed \(newMed)")
//                        print("data \(document.data())")
                    }
                    self.medications[self.CURRENT]?.sort(by: >)
                    self.medications[self.DISCONTINUED]?.sort(by: >)
//                    self.oldMedications.sort(by: <)
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "medCell")
    }
    
    // define what shows up in each cell here
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("in create cells")
        let myCell = UITableViewCell(style: .subtitle, reuseIdentifier: "medCell")
        let medOptional = medications[indexPath.section]?[indexPath.row]
        guard let med = medOptional else {
            return myCell;
        }
        myCell.textLabel!.text = med.name
        
       
        if let dose = med.dose {
            if let frequency = med.frequency {
                myCell.detailTextLabel!.text = "Dosage: \(dose)\nFrequency: \(frequency)"
            }
            else {
                 myCell.detailTextLabel!.text = "Dosage: \(dose) Frequency: "
            }
        }
        else {
            if let frequency = med.frequency {
                myCell.detailTextLabel!.text = "Dosage: \nFrequency: \(frequency)"
            }
            else {
                myCell.detailTextLabel!.text = "Dosage: \nFrequency: "
            }
        }
        myCell.detailTextLabel?.numberOfLines=0 // line wrap
        myCell.detailTextLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        myCell.clipsToBounds = true
         let myView = UIView(frame: CGRect(x: 10, y: 5, width: 393, height: 87))
         myView.backgroundColor = UIColor.white
         myView.layer.masksToBounds = false
         myView.layer.cornerRadius = 5
         myView.layer.shadowColor = UIColor.lightGray.cgColor
        myView.layer.shadowOpacity = 0.7
         myView.layer.shadowOffset = CGSize(width: 1, height: 2)
         myView.layer.shadowRadius = 2
         myCell.addSubview(myView)
         myCell.sendSubviewToBack(myView)
        myCell.selectionStyle = .none
        
        
//        let bgColorView = UIView()
//        bgColorView.backgroundColor = UIColor.red
//        myCell.selectedBackgroundView = bgColorView
        
        
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // define number of rows here
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medications[section]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if medications.count != 0 { //so that no headers show up immediately
            if section == 0 {
                return "Current"
            }
            return "Discontinued"
        }
        return nil
    }
    //var selectionStyle: UITableViewCell.SelectionStyle
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 10, y: 10, width: 320, height: 30)
        myLabel.font = UIFont.boldSystemFont(ofSize: 20)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        myLabel.textColor = UIColor(hue: (240.0/360), saturation: 0.74, brightness: 0.92, alpha: 1.0)
        let headerView = UIView()
       // headerView.backgroundColor = UIColor(hue: (240.0/360), saturation: 0.74, brightness: 0.92, alpha: 1.0)
//        headerView.backgroundColor = UIColor.white
        headerView.addSubview(myLabel)
        return headerView
    }
    
    
    
    
    // define what to do on clicking an item here (most likely detailed view segue)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("in did select row")
        selectedMed = medications[indexPath.section]?[indexPath.row]
        self.performSegue(withIdentifier: "medDetailsSegue", sender: self)
        //self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem("back")
//        let vc = .destination as! DetailedMedViewController
//        vc.medication = medications[indexPath.row]
//        DetailedMedViewController.medication = medications[indexPath.row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailedMedViewController {
            vc.medication = selectedMed
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
