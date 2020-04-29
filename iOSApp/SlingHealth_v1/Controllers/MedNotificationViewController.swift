//
//  MedNotificationViewController.swift
//  SlingHealth_v1
//
//  Created by user168467 on 4/23/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import Foundation
import UIKit

class MedNotificationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var medication: Medication!
    
    var freqToWordTimes: [String : [String]] = ["Once a day" : ["Time 1"], "Twice a day" : ["Time 1", "Time 2"], "Three times a day" : ["Time 1", "Time 2", "Time 3"], "Four times a day" : ["Time 1", "Time 2", "Time 3", "Time 4"], "Every two days" : ["Time 1"], "Once a week" : ["Time 1"], "As needed" : ["Time 1"]]
    
    //FIXME change times for Every two days, once a week, and as needed
    
    var wordTimes: [String]?

    
//    var wordTimes: [String] = ["Time 1", "Time 2", "Time 3", "Time 4"]

    @IBOutlet weak var wordTimesPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.wordTimesPicker.delegate = self
        self.wordTimesPicker.dataSource = self
        wordTimes = freqToWordTimes[medication.frequency]

        if wordTimes == nil || wordTimes!.count < 1 {
            if let navController = self.navigationController {
                navController.popViewController(animated: false)
            }
        }
    }
    
    
    @IBAction func setReminder(_ sender: Any) {
        let selectedWordTime = wordTimes![wordTimesPicker.selectedRow(inComponent: 0)]
        let selectedDate = timePicker.date
        let hour = Calendar.current.component(.hour, from: selectedDate)
        let min = Calendar.current.component(.minute, from: selectedDate)
        
        let newTime = DateComponents(hour: hour, minute: min)
        createMedSpecificNotification(med: medication, wordTimeNum: selectedWordTime, time: newTime)
//        timesOfDay.updateValue(newTime, forKey: selectedWordTime)
    }
    
    
    @IBAction func addToGeneral(_ sender: Any) {
        //FIXME make it add to General Meds
    }
    
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wordTimes!.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        wordTimes![row]
    }

}
