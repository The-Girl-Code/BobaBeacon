//
//  ProfileViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/20/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var storeTextField: UITextField!
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var bobaImage: UIButton!
    
    var flavorSelected: String? {
        willSet {
            drinkLabel.text = "\(newValue!)"
            bobaImage.setImage(UIImage(named: newValue!), for: .normal)
        }
    }
    
    @IBAction func unwindFromCancelToProf(segue: UIStoryboardSegue){
        
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do{
                try? Auth.auth().signOut()
                
                if Auth.auth().currentUser == nil {
                    let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
                
                self.present(loginVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "toPlaces", sender: self)
        return false
    }
    
    @IBAction func unwind2Profile(segue: UIStoryboardSegue){
        if let sourceViewController = segue.source as? PlaceViewController {
            dataRecieved = sourceViewController.dataPassed
        }
        else if let sourceViewController = segue.source as? FaveViewController {
            flavorSelected = (sourceViewController.flavor)!
            print(flavorSelected!)
        }
    }
    
    var dataRecieved: String? {
        willSet {
            storeTextField.text = "  \(newValue!)"
        }
    }
    
    func presentActionSheet(from viewController: UIViewController) {
        // 1
        let alertController = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                
                self.presentImagePickerController(with: .camera, from: viewController)
            })
            
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload Photo", style: .default, handler: { action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })
            
            alertController.addAction(uploadAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    
    var completionHandler: ((UIImage) -> Void)?

    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        viewController.present(imagePickerController, animated: true)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let username = snapshot.childSnapshot(forPath: (Auth.auth().currentUser?.uid)!).childSnapshot(forPath: "username").value
                self.usernameLabel.text = "\(username!)"
        })
        storeTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.setRounded()

        profileImage.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.presentImagePickerController(with: .photoLibrary, from: self)

        // Your action
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
            profileImage.image = selectedImage
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}


