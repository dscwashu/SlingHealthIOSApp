//
//  UtilityFunctions.swift
//  SlingHealth_v1
//
//  Created by Priyanshu on 21/12/19.
//  Copyright © 2019 Priyanshu. All rights reserved.
//

import Foundation
import UIKit

func createAlert(title:String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
    return alert
}
