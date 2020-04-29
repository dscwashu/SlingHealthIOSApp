//
//  FormMedViewController.swift
//  SlingHealth_v1
//
//  Created by Faith Letzkus on 1/19/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FormMedViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var editedMed : Medication?
    
    let db = Firestore.firestore()
    
    //Make user public static in profile/health/i dont know file
    var user = Auth.auth().currentUser;

    let frequencyData = ["Once a day", "Twice a day", "Three times a day", "Four times a day", "Every two days", "Once a week", "As needed"]
    
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var doseInput: UITextField!
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var frequencyInput: UIPickerView!
    @IBOutlet weak var notesInput: UITextField!
    @IBOutlet weak var prescriberInput: UITextField!
    @IBOutlet weak var stillTakingSwitch: UISwitch!
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var setTimesButton: UIButton!
    
    @IBOutlet weak var createEditButtonOutlet: UIButton!
    
    
    var medication : Medication?
    var medId : Int?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frequencyInput.delegate = self
        self.frequencyInput.dataSource = self
        
        dateInput.setDate(Date(), animated: false)
        
        
        //FIXME
        // - Make custom view subview containing the label and list of reasons.
        // - Change placement to be correct in scroll view.
        // - Does not dynamically change size. Just can appear and disappear which
        //would look weird with a ton of empty space
        //
        //IDEA: place in storyboard and just toggle hidden field in code
        //rather than creating it programmatically. I couldn't figure out
        //how to "scroll" in the scroll view in storyboard.
//        reasonLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//        reasonLabel.center = CGPoint(x: 160, y: 284)
//        reasonLabel.text = "TESTING THIS THING"
        
        
        setUpFieldsForEdit()
        
    }
    
    func setUpFieldsForEdit() {
        guard let med = medication else {
            print("medication does not already exist")
            return
        }
        medId = med.id
        createEditButtonOutlet.setTitle("Update Medication", for: .normal)
        
        //FIXME
        //Once everything is established, can probably get rid of all the nil checks
        //except on Notes because a med should have all these categories filled,
        //so the check for med above should be enough. But probably keep through
        //Sling Health deadline because helps spot bugs and won't crash if
        //database changes
        
        //If editing then prefill forms
        if med.name != nil {
            nameInput.text = med.name
        }
        if med.dose != nil {
            doseInput.text = med.dose
        }
        
        if med.startDate != nil {
            dateInput.setDate(med.startDate, animated: false)
        }
        
        if med.notes != nil {
            notesInput.text = med.notes
        }
        if med.prescriber != nil {
            prescriberInput.text = med.prescriber
        }
        if med.stillTaking != nil {
            stillTakingSwitch.setOn(med.stillTaking!, animated: false)
        }
        if med.reminder != nil {
            reminderSwitch.setOn(med.reminder!, animated: false)
            setTimesButton.isHidden = !med.reminder!
            
        }
        if med.frequency != nil {
            guard let row = frequencyData.firstIndex(of: med.frequency) else {
                print("invalid frequency")
                return
            }
            frequencyInput.selectRow(row, inComponent: 0, animated: false)
        }
    }
    
    @IBAction func createMedButton(_ sender: Any) {
        let selectedFrequency = frequencyData[frequencyInput.selectedRow(inComponent: 0)]
        print("frequency: \(selectedFrequency)")
        if nameInput.text != "" &&  doseInput.text != "" &&  dateInput != nil && frequencyInput != nil {
            
            
//            var newMed = Medication(name: nameInput.text, description: descriptionInput.text, startDate: dateInput.date, frequency: selectedFrequency, notes: notesInput.text)
//            print(newMed)
            print(user!.uid)
            //try out .updateData instead of .setData if it already exists so that things update properly
            
            //FIXME
            //Generate an id for the medication
            
            db.collection("medication").document("\(user!.uid)")
              .collection("user_meds").document("\(nameInput.text!)")
              .setData(
                [ "name" : nameInput.text!,
                  "dose" : doseInput.text!,
                  "startDate" : dateInput.date,
                  "frequency" : selectedFrequency,
                  "prescriber" : prescriberInput.text!,
                  "notes" : notesInput.text!,
                  "stillTaking": stillTakingSwitch.isOn,
                  "reminder" : reminderSwitch.isOn,
                  "user" : user!.uid
                ]
              )
              { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
                else {
                    print("Document successfully written!")
                    self.medication = Medication(id: nil, name: self.nameInput.text!, dose: self.doseInput.text!, startDate: self.dateInput.date, frequency: selectedFrequency, prescriber: self.prescriberInput.text!, notes: self.notesInput.text!, stillTaking: self.stillTakingSwitch.isOn, reminder: self.reminderSwitch.isOn)
//                    unwind(for: <#T##UIStoryboardSegue#>, towards: DetailedMedViewController)
//                    _ = self.navigationController?.popViewController(animated: true)
                        //.//listenDocumentLocal()
//                    if !self.medication!.stillTaking || self.medication!.frequency == "As needed" { //remove if discontinued
//                        removeMedNotifications(med: self.medication!)
//                    }
//                    else if self.medication!.frequency != "As needed" {
//                        createMedNotifications(med: self.medication!)
//                    }
                    if !self.medication!.reminder { //no more reminders
                        removeMedNotifications(med: self.medication!)
                    }
                    //FIXME if frequency is changed, update notifications accordingly
                }
              }
        }
        else {
            //Alert that says upload didn't work
            let alert = UIAlertController(title: "Incomplete Form", message: "Please fill all necessary fields.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                print("User clicked Okay")
            }))

            self.present(alert, animated: true)
        }
    }
    
    @IBAction func stillTakingChanged(_ sender: Any) {
        print("start stillTakingChanged")
//        if stillTakingSwitch.isOn {
//            self.view.addSubview(reasonLabel)
//        }
//        else {
//            reasonLabel.removeFromSuperview()
//        }
        print("end stillTakingChanged")
    }
    
    @IBAction func reminderChanged(_ sender: Any) {
        setTimesButton.isHidden = !reminderSwitch.isOn
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return frequencyData[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedFrequency = frequencyData[frequencyInput.selectedRow(inComponent: 0)]
        editedMed = Medication(id: medId, name: nameInput.text, dose: doseInput.text, startDate: dateInput.date, frequency: selectedFrequency, prescriber: prescriberInput.text, notes: notesInput.text, stillTaking: stillTakingSwitch.isOn)
        print("preparing for detailedmedviewcontroller segue")
        
        if let vc = segue.destination as? DetailedMedViewController {
               vc.medication = editedMed
           }
        else if let vc = segue.destination as? MedNotificationViewController {
            vc.medication = editedMed
        }
           
       }
    
//    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
//        guard let vc = unwindSegue.destination as? DetailedMedViewController else {
//            print("cannot be casted to DetailedMedViewController")
//            return
//        }
//        vc.medication = medication
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
