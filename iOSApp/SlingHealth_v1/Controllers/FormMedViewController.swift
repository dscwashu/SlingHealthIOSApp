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

    let frequencyData = ["Every 2 hours", "Four times a day", "Three times a day", "Twice a day", "Once a day", "Every Two Days", "Once a week"]
    
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var doseInput: UITextField!
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var frequencyInput: UIPickerView!
    @IBOutlet weak var notesInput: UITextField!
    @IBOutlet weak var prescriberInput: UITextField!
    @IBOutlet weak var stillTakingSwitch: UISwitch!
    @IBOutlet weak var createEditButtonOutlet: UIButton!
    
    var medication : Medication?
    var medId : Int?
    
    //For editing
    var oldName : String?
    var oldDose : String?
    
    //FIXME
    //Missing oldDate
    //Missing oldFrequency
    
    var oldNotes : String?
    var oldPrescriber : String?
    var oldStillTaking: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frequencyInput.delegate = self
        self.frequencyInput.dataSource = self
        
        dateInput.setDate(Date(), animated: false)
        
        guard let med = medication else {
            print("medication does not already exist")
            return
        }
        medId = med.id
        createEditButtonOutlet.setTitle("Update Medication", for: .normal)
        
        //FIXME
        //Once everything is established, can probably get rid of all the nil checks
        //except on Notes because a med should have all these categories filled,
        //so the check for med above should be enough
        
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
        
        //FIXME
        //Missing oldFrequency
        print("med.frequency: \(med.frequency)")
//        frequencyInput.value
//        frequencyInput = med.frequency
        if med.frequency != nil {
            guard let row = frequencyData.firstIndex(of: med.frequency) else {
                print("invalid frequency")
                return
            }
            print("first inde of freq is: \(row)")
            frequencyInput.selectRow(row, inComponent: 0, animated: false)
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
                  "user" : user!.uid
                ]
              )
              { err in
                if let err = err {
                    print("Error writing document: \(err)")
                }
                else {
                    print("Document successfully written!")
                    self.medication = Medication(id: nil, name: self.nameInput.text!, dose: self.doseInput.text!, startDate: self.dateInput.date, frequency: selectedFrequency, prescriber: self.prescriberInput.text!, notes: self.notesInput.text!, stillTaking: self.stillTakingSwitch.isOn)
//                    unwind(for: <#T##UIStoryboardSegue#>, towards: DetailedMedViewController)
//                    _ = self.navigationController?.popViewController(animated: true)
                        //.//listenDocumentLocal()
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
