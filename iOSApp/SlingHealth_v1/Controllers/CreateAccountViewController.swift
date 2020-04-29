//
//  CreateAccountViewController.swift
//  SlingHealth_v1
//
//  Created by Priyanshu on 21/12/19.
//  Copyright © 2019 Priyanshu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createAccountAction(_ sender: Any) {
        // check for empty text fields
        if emailBox.text == nil || passwordBox.text == nil {
            let alert = createAlert(title: "Incomplete", message: "Please fill out all the boxes. Feel free to write N/A for those that you wish to leave blank!")
            self.present(alert, animated: true, completion: nil)
        }
        else {
            Auth.auth().createUser(withEmail: self.emailBox.text!, password: self.passwordBox.text!) { (authResult, error) in
                
                if error == nil {
                    Auth.auth().signIn(withEmail: self.emailBox.text!,
                                       password: self.passwordBox.text!)
                    
                    // TODO: ADD RELATED ENTRY IN DATABASE
                    // Add a new document with a generated ID
                    self.db.collection("users").document(Auth.auth().currentUser!.uid).setData([
                        "userID": Auth.auth().currentUser!.uid,
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(Auth.auth().currentUser!.uid)")
                        }
                    }
                    
                    self.performSegue(withIdentifier: "logInFromCreateAccount", sender: nil)
                }
                else {
                    let alert = createAlert(title: "Error", message: error!.localizedDescription as String)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    

}
