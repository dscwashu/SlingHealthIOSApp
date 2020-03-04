//
//  DetailedMedViewController.swift
//  SlingHealth_v1
//
//  Created by Faith Letzkus on 2/3/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit

class DetailedMedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var editButtonOutlet: UIButton!
    
    
    @IBAction func editButtonAction(_ sender: Any) {
        print("entered edit button Action")
        self.performSegue(withIdentifier: "editMedicationSegue", sender: self)
    }
    
    
    @IBOutlet weak var detailedTableView: UITableView!
    
    public var medication: Medication!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7 //number of variables Medication has
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if medication != nil {
            cell.textLabel!.text = getMedVal(index: indexPath.section)
        }
        return cell
    }
    
    func getMedVal(index : Int) -> String {
        guard let med = medication else {
            return ""
        }
        switch(index) {
        case 0: return med.name
        case 1:
            guard let dose = med.dose else {return ""}
            return dose
        case 2:
            guard let frequency = med.frequency else {return ""}
            return frequency
        case 3:
            guard let startDate = med.startDate else {return ""}
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: startDate)
        case 4:
            guard let prescriber = med.prescriber else {return ""}
            return prescriber
        case 5:
            guard let notes = med.notes else {return ""}
            return notes
        case 6:
            guard let stillTaking = med.stillTaking else {return ""}
            if(stillTaking) {
                return "Yes"
            }
            return "No"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return getSectionHeader(index: section)
    }
    
    func getSectionHeader(index : Int) -> String {
        switch(index) {
        case 0: return "Name"
        case 1: return "Dose"
        case 2: return "Frequency"
        case 3: return "Date"
        case 4: return "Prescriber"
        case 5: return "Notes"
        case 6: return "Still Taking?"
        default: return ""
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(medication)
        detailedTableView.dataSource = self
        detailedTableView.delegate = self
        
        print("view did load in detailed")
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("in detaile now: \(medication)")
        detailedTableView.reloadData()
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        //don't delete this function
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("entered segue override")
        guard let vc = segue.destination as? FormMedViewController else {
            print("cannot be casted to FormMedViewController")
            return
        }
        print(medication.name!)
//        vc.nameInput.text = "test"
//        vc.nameInput.text = medication.name
//        vc.doseInput.text = medication.dose
//        //FIXME
//        //vc.dateInput.date = medication.startDate
////        vc.frequencyInput = medication.frequency
//        if medication.notes != nil { //Notes not a required field so could be nil
//            vc.notesInput.text = medication.notes
//        }
//        vc.prescriberInput.text = medication.prescriber
        
        vc.medication = medication
//        vc.oldName = medication.name
//        vc.oldDose = medication.dose
//        if medication.notes != nil { //Notes not a required field so could be nil
//            vc.oldNotes = medication.notes
//        }
//        vc.oldPrescriber = medication.prescriber
//        vc.oldStillTaking = medication.stillTaking
    }
    
    
//    @IBAction func unwindToMedsTableViewController(segue: UIStoryboardSegue) {
//        viewDidLoad()
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
