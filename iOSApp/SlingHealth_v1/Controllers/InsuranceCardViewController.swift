//
//  InsuranceCardViewController.swift
//  SlingHealth_v1
//
//  Created by Priyanshu on 07/02/20.
//  Copyright © 2020 Priyanshu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class InsuranceCardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // required references
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()

    // UI component outlets
    @IBOutlet weak var insuranceFrontImageView: UIImageView!
    @IBOutlet weak var insuranceBackImageView: UIImageView!
    @IBOutlet weak var idProofImageView: UIImageView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var editOrSaveBarButton: UIBarButtonItem!
    
    // needed variables
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isEditing = false
        
        // load the insurance card image
        getInsuranceCardImages()
        
        // add gestures to allow image uploading in edit mode
        insuranceFrontImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnImageView)))
        insuranceBackImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnImageView)))
        idProofImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnImageView)))
        
    }
    
    // gets the insurance card images from firebase storage
    // default: template images
    func getInsuranceCardImages() {
        // file paths for insurance card images as per structure
        let frontImagePath = "insuranceCard/front/" + Auth.auth().currentUser!.uid
        let backImagePath = "insuranceCard/back/" + Auth.auth().currentUser!.uid
        let idPath = "insuranceCard/id/" + Auth.auth().currentUser!.uid
        
        // reference to the files in google storage
        let frontRef = storageRef.child(frontImagePath)
        let backRef = storageRef.child(backImagePath)
        let idRef = storageRef.child(idPath)
        
        // Download in memory with a maximum allowed size of 4MB (4 * 1024 * 1024 bytes)
        // download front image
        frontRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error {
                // error occurred, most likely file not exists
                print(error)
                self.insuranceFrontImageView.image = UIImage(named: "InsuranceCardFrontTemp.png")
                self.actionLabel.isHidden = false
            } else {
                // image is returned
                let image = UIImage(data: data!)
                self.insuranceFrontImageView.image = image
                // print(image)
            }
        }
        
        // download back image
        backRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error {
                // error occurred, most likely file not exists
                print(error)
                self.insuranceBackImageView.image = UIImage(named: "InsuranceCardBackTemp.png")
                self.actionLabel.isHidden = false

            } else {
                // image is returned
                let image = UIImage(data: data!)
                self.insuranceBackImageView.image = image
                // print(image)
            }
        }
        
        // download id proof image
        idRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
            if let error = error {
                // error occurred, most likely file not exists
                print(error)
                self.idProofImageView.image = UIImage(named: "InsuranceCardFrontTemp.png")
                self.actionLabel.isHidden = false
                
            } else {
                // image is returned
                let image = UIImage(data: data!)
                self.idProofImageView.image = image
                // print(image)
            }
        }
    }
    
    func uploadImagesToFirebase() {
        // create reference
        let imagesRef = storageRef.child("insuranceCard")
        
        // create exact file reference with username for each
        let frontName = "/front/" + Auth.auth().currentUser!.uid
        let backName = "/back/" + Auth.auth().currentUser!.uid
        let idName = "/id/" + Auth.auth().currentUser!.uid
        let frontRef = imagesRef.child(frontName)
        let backRef = imagesRef.child(backName)
        let idRef = imagesRef.child(idName)
        
        // get image from the front image view if not nil
        if let uploadData = self.insuranceFrontImageView.image!.pngData() {
            // upload image at this path
            _ = frontRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
        // get image from the back image view if not nil
        if let uploadData = self.insuranceBackImageView.image!.pngData() {
            // upload image at this path
            _ = backRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
        // get image from the id proof view if not nil
        if let uploadData = self.idProofImageView.image!.pngData() {
            // upload image at this path
            _ = idRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    // Uh-oh, an error occurred!
                    return
                }
            }
        }
        
        return
    }
    
    @IBAction func switchEditingMode(_ sender: Any) {
        if self.isEditing {
            // Save
            self.isEditing = false
            insuranceFrontImageView.isUserInteractionEnabled = false
            insuranceBackImageView.isUserInteractionEnabled = false
            idProofImageView.isUserInteractionEnabled = false
            editOrSaveBarButton.title = "Edit"
            uploadImagesToFirebase()
        }
        else {
            // Edit
            self.isEditing = true
            self.actionLabel.isHidden = true
            insuranceFrontImageView.isUserInteractionEnabled = true
            insuranceBackImageView.isUserInteractionEnabled = true
            idProofImageView.isUserInteractionEnabled = true
            editOrSaveBarButton.title = "Save"
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTapOnImageView(sender: UITapGestureRecognizer) {
        if sender.view?.tag == 1 {
            self.imageView = insuranceFrontImageView
        }
        else if sender.view?.tag == 2 {
            self.imageView = insuranceBackImageView
        }
        else if sender.view?.tag == 3 {
            self.imageView = idProofImageView
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker,animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImage : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            pickedImage = editedImage
        }
        else if let ogImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            pickedImage = ogImage
        }
        if let pImage = pickedImage{
            self.imageView.image = pImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
