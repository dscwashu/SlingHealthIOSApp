//
//  FormCareTeamsViewController.swift
//  SlingHealth_v1
//
//  Created by Faith Letzkus on 3/8/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FormCareTeamsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Need to complete this file
    
    let db = Firestore.firestore()
    var user = Auth.auth().currentUser;
    
    let specialtyData = ["Cardiology", "Dermatology", "Endocrinology", "Gastroenterology", "Gynecology", "Hepatology", "Infectious Disease", "Nephrology", "Oncology", "Ophthalmology", "Orthopedics", "Pediatrics", "Primary Care", "Psychiatry", "Pulmonology", "Rheumatology", "Transplant", "Urology", "Other"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return specialtyData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return specialtyData[row]
    }
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var specialtyInput: UIPickerView!
    @IBOutlet weak var phyNumInput: UITextField!
    @IBOutlet weak var nurseInput: UITextField!
    @IBOutlet weak var careInput: UITextField!
    @IBOutlet weak var careNumInput: UITextField!
    
     var careTeam : CareTeam?
    var teamId : Int?
    
    @IBAction func addToTeam(_ sender: Any) {
        let selectedSpecialty = specialtyData[specialtyInput.selectedRow(inComponent: 0)]
                if nameInput.text != "" && specialtyInput != nil {
                    
                    print(user!.uid)
                    
                    db.collection("teams").document("\(user!.uid)")
                      .collection("user_teams").document("\(nameInput.text!)")
                      .setData(
                        [ "physician" : nameInput.text!,
                          "physicianNumber" : Int(phyNumInput.text ?? "0")!,
                          "specialty" : selectedSpecialty,
                          "nurse" : nurseInput.text ?? "",
                          "caretaker" : careInput.text ?? "",
                          "caretakerNumber" : Int(careNumInput.text ?? "0")!,
                          "user" : user!.uid
                        ]
                      )
                      { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                        else {
                            print("Document successfully written!")
                            self.careTeam = CareTeam(id: nil, physician: self.nameInput.text!, specialty: selectedSpecialty, physicianNumber: Int(self.phyNumInput.text!), nurse: self.nurseInput.text, caretaker: self.careInput.text!, caretakerNumber: Int(self.careNumInput.text!))
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.specialtyInput.delegate = self
        self.specialtyInput.dataSource = self
        
        setUpFieldsForEdit()

        // Do any additional setup after loading the view.
    }
    
    func setUpFieldsForEdit() {
        if let team = careTeam  {
            teamId = team.id
            
            nameInput.text = team.physician
            phyNumInput.text = String(team.physicianNumber)
            nurseInput.text = team.nurse
            careInput.text = team.caretaker
            careNumInput.text = String(team.caretakerNumber)
            
            guard let row = specialtyData.firstIndex(of: team.specialty) else {
                print("invalid specialty")
                return
            }
            specialtyInput.selectRow(row, inComponent: 0, animated: false)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
