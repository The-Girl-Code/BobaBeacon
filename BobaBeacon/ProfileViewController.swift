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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var borderImageView: UIImageView!

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
    
    @IBAction func unwindFromOtherCancelToProf(segue: UIStoryboardSegue){
        
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
            let ref = Database.database().reference().child("users").child("\(User.current.uid)")
            let value = ["fav_store" : dataRecieved]
            ref.updateChildValues(value)
        }
        else if let sourceViewController = segue.source as? FaveViewController {
            flavorSelected = (sourceViewController.flavor)!
            let ref = Database.database().reference().child("users").child("\(User.current.uid)")
            let value = ["fav_drink" : flavorSelected]
            ref.updateChildValues(value)
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
            let place = snapshot.childSnapshot(forPath: (Auth.auth().currentUser?.uid)!).childSnapshot(forPath: "fav_store").value
            self.storeTextField.text = "\(place!)"
            let drink = snapshot.childSnapshot(forPath: (Auth.auth().currentUser?.uid)!).childSnapshot(forPath: "fav_drink").value
            self.drinkLabel.text = "\(drink!)"
            self.bobaImage.setImage(UIImage(named: drink as! String), for: .normal)
        })
        storeTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
                // Do any additional setup after loading the view.
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 750)
        
        
        let flavorImages: [UIImage] = [
            UIImage(named: "Regular")!,
            UIImage(named: "Peach")!,
            UIImage(named: "Coffee")!,
            UIImage(named: "Green Tea")!,
            UIImage(named: "Strawberry")!,
            UIImage(named: "Jasmine")!,
            UIImage(named: "Thai")!,
            UIImage(named: "Honeydew")!,
            UIImage(named: "Taro")!,
            UIImage(named: "Almond")!,
            UIImage(named: "Chocolate")!,
            UIImage(named: "Lychee")!,
            UIImage(named: "Black Tea")!,
            UIImage(named: "Oolong")!,
            UIImage(named: "Passion Fruit")!,
            UIImage(named: "Hazelnut")!,
            UIImage(named: "Mango")!]
        let randomIndex = Int(arc4random_uniform(UInt32(flavorImages.count)))
        profileImage.image = flavorImages[randomIndex]
        
        profileImage.isUserInteractionEnabled = true
        borderImageView.setRounded()
        profileImage.setRounded()
        
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        self.view.bringSubview(toFront: profileImage)
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


