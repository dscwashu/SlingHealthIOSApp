//
//  Notification.swift
//  SlingHealth_v1
//
//  Created by user168467 on 4/8/20.
//  Copyright © 2020 Collin. All rights reserved.
//

import Foundation
import UserNotifications

//let frequencies: [(frequency: String, ids: [Int])] = [("Once a day", [0]), ("Twice a day", [0, 2]), ("Three times a day", [0, 1, 2]), ("Four times a day", [0, 1, 2, 3])] //, "Every two days", "Once a week", "As needed"]


var freqToTimesOfDay: [String : [String]] = ["Once a day" : ["morning"], "Twice a day" : ["morning", "evening"], "Three times a day" : ["morning", "afternoon", "evening"], "Four times a day" : ["morning", "afternoon", "evening", "4th time"]]

//var timesOfDay: [String : (Int, Int)] = ["morning" : (8, 30), "afternoon" : (12, 0), "evening" : (19, 0), "4th time" : (16, 0)]

public var timesOfDay: [String : DateComponents] = ["morning" : DateComponents(hour: 1, minute: 23), "afternoon" : DateComponents(hour: 1, minute: 8), "evening" : DateComponents(hour: 1, minute: 24), "4th time" : DateComponents(hour: 16, minute: 0)]

var wordTimes: [String] = ["morning", "afternoon", "evening", "4th time"]

var wordTimesNums: [String] = ["Time 1", "Time 2", "Time 3", "Time 4"]

//var timeForPills = [NSCalendar.date(<#T##self: NSCalendar##NSCalendar#>)]

//FIXME eventually allow user to change times
//var times: [(hour: Int, min: Int)] = [(8, 30), (12, 0), (19,0), (16, 0)]


func createMedNotifications(med: Medication) {
    
    // FIXME add should replace notification. If it doesn't, uncomment remove
    //Remove all previously created notifications
    //removeMedNotifications(med: med)
    
    let content = UNMutableNotificationContent()
    content.title = "\(med.name!)"
    content.body = "Take \(med.dose!)"
    content.sound = UNNotificationSound.default


    let timeOfDay = freqToTimesOfDay[med.frequency]

    if timeOfDay == nil { // FIXME eventually take out when all frequencies work
        print("No valid option yet for frequency: \(med.frequency!)")
        return
    }
    
    for wordTime in timeOfDay! {
        print(wordTime)
        
        //add replac
        let identifier = "\(wordTime)\(med.name!)Notification"
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: timesOfDay[wordTime]!, repeats: true)
        
        //Possibly use identifier to replace
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
}

func createMedSpecificNotification(med: Medication, wordTimeNum: String, time: DateComponents) {
    let content = UNMutableNotificationContent()
    content.title = "\(med.name!)"
    content.body = "Take \(med.dose!)"
    content.sound = UNNotificationSound.default
    
    
    let identifier = "\(wordTimeNum)\(med.name!)Notification"
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
    
    //Possibly use identifier to replace
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    
}



func removeMedNotifications(med: Medication) {
    
    //FIXME add removal from General Meds
    
    var identifiers = [String]()
    
    // Find all possible notifications for this med
    for word in wordTimes {
        identifiers.append("\(word)\(med.name!)Notification")
    }
    
    for word in wordTimesNums {
        identifiers.append("\(word)\(med.name!)Notification")
    }
    
    //Remove old notification(s) for this med
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
}





//func updateTimeNotifications(String: wordTime) {
//    UNNotificationRequest.
//    UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: @escapingcompletionHandler: <#([UNNotificationRequest]) -> Void#>)
//}

