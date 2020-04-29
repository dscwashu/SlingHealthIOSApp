//
//  HealthProfileViewController.swift
//  SlingHealth_v1
//
//  Created by Priyanshu on 20/01/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit
import FirebaseAuth

class HealthProfileViewController: UIViewController {

    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var insuranceCardView: UIImageView!
    @IBOutlet weak var pharmacyField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutAction(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logoutSegue", sender: nil)
        }
        catch let error {
            print("failed to sign out with error: \(error)")
        }
        
    }
    
    
    
}
