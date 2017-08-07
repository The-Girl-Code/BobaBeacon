//
//  RecommendationViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/24/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class RecommendationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    //var scrollView: UIScrollView!
    //var containerView = UIView()
    
    
    @IBOutlet weak var storeTextField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var bobaImage: UIButton!
    
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    
    var ref : DatabaseReference!

    
    @IBAction func unwindFromCancel(segue: UIStoryboardSegue){
        
    }
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToFeed", sender: self)
    }
    

    
    @IBAction func postButtonTapped(_ sender: UIBarButtonItem) {
        postRec()
        print("post button was tapped")
        self.performSegue(withIdentifier: "unwindToFeed", sender: self)
     
    }
    
    
    
    @IBAction func unwind2Recommendation(segue: UIStoryboardSegue){
       if let sourceViewController = segue.source as? StoresViewController {
            dataRecieved = sourceViewController.dataPassed
        print(dataRecieved)
        }
        
        else if let sourceViewController = segue.source as? FlavorsViewController {
            flavorSelected = sourceViewController.flavor
            print(flavorSelected)
        }
    }
    
    
    
    var dataRecieved: String? {
        willSet {
            storeTextField.text = "  \(newValue!)"
        }
    }
    
    var flavorSelected: String? {
        willSet {
            drinkLabel.text = "\(newValue!)"
            bobaImage.setImage(UIImage(named: newValue!), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        disablePost()
        textView.text = "Write a short description about your favorite flavor here..."
        textView.textColor = UIColor.lightGray

        storeTextField.delegate = self
        textView.delegate = self
//        self.scrollView = UIScrollView()
//        self.scrollView.delegate = self
//        self.scrollView.contentSize = CGSize(width: 360, height: 550)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 750)
        self.hideKeyboardWhenTappedAround()

    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        scrollView.frame = view.bounds
//        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
//    }
//    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        performSegue(withIdentifier: "toStores", sender: self)
        
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        postButton.isEnabled = true
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a short description about your favorite flavor here..."
            textView.textColor = UIColor.lightGray
            postButton.isEnabled = false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        postButton.isEnabled = true
    }
    
    func postRec(){
        ref = Database.database().reference()
        let storeText = storeTextField.text
        let drink = drinkLabel.text
        let rec = textView.text
        
        PostService.createRec(drink: drink!, location: storeText!, recommendation: rec!)
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func disablePost(){
        if (storeTextField.text?.isEmpty)! {
            postButton.isEnabled = false
        }
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
