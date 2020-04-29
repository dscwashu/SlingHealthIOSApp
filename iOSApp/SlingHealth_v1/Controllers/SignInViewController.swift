//
//  SignInViewController.swift
//  SlingHealth_v1
//
//  Created by Priyanshu on 21/12/19.
//  Copyright © 2019 Priyanshu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var passwordBox: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "logInFromSignIn", sender: nil)
                print("previously signed in")
            }

        }
    }


    @IBAction func signInAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailBox.text!, password: passwordBox.text!) { (user, error) in
            if error==nil{
                self.performSegue(withIdentifier: "logInFromSignIn", sender: nil)
                print("signed in")
                
            }
            else{
                // print(error)
                let alert = createAlert(title: "Error", message: (error?.localizedDescription)!)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
