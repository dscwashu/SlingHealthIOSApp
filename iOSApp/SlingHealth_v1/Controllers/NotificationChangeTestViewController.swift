//
//  NotificationChangeTestViewController.swift
//  SlingHealth_v1
//
//  Created by user168467 on 4/17/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import Foundation
import UIKit

class NotificationChangeTestViewContoller: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var wordTimes: [String] = ["morning", "afternoon", "evening", "4th time"]
    
    @IBOutlet weak var wordTimesPicker: UIPickerView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.wordTimesPicker.delegate = self
        self.wordTimesPicker.dataSource = self
    }
    
    
    
    @IBAction func changeTimeAction(_ sender: Any) {
        let selectedWordTime = wordTimes[wordTimesPicker.selectedRow(inComponent: 0)]
        let selectedDate = timePicker.date
        let hour = Calendar.current.component(.hour, from: selectedDate)
        let min = Calendar.current.component(.minute, from: selectedDate)
        
        let newTime = DateComponents(hour: hour, minute: min)
        timesOfDay.updateValue(newTime, forKey: selectedWordTime)
        
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wordTimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        wordTimes[row]
    }
    
    
}

