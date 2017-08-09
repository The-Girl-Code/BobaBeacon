//
//  ReviewViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/24/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit
import FloatRatingView
import Former
import Firebase
import FirebaseDatabase
import FirebaseStorage


class ReviewViewController: UIViewController, FloatRatingViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var liveLabel: UILabel!
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    @IBOutlet weak var reviewScrollView: UIScrollView!

    var ref : DatabaseReference!
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        print("cancel button tapped")
         self.performSegue(withIdentifier: "unwindToFeed", sender: self)
    }

    @IBAction func unwindToReview(segue: UIStoryboardSegue){
        if let sourceViewController = segue.source as? LocationViewController {
            dataRecieved = sourceViewController.dataPassed
        }
    }
    
    @IBAction func unwindFromSearchCancel(segue: UIStoryboardSegue){
        
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        if (reviewTextView.text.isEmpty){
            print("more ug")
        }
        if (locationTextField.text?.isEmpty == false) && (reviewTextView.text.isEmpty == false){
            print("done button was tapped")
            postReview()
            print("UGGGGGGG")
            self.performSegue(withIdentifier: "unwindToFeed", sender: self)
        }else{
            postButton.isEnabled = false
        }
    }
    
    var dataRecieved: String? {
        willSet {
            locationTextField.text = "  \(newValue!)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disablePost()
        locationTextField.delegate = self
        reviewTextView.delegate = self
        
        self.ratingView.emptyImage = UIImage(named: "boba-empty")
        self.ratingView.fullImage = UIImage(named: "Regular")
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 0
        self.ratingView.rating = 2.5
        self.ratingView.editable = true
        self.ratingView.halfRatings = true
        self.ratingView.floatRatings = false
        
        self.liveLabel.text = NSString(format: "%.2f", self.ratingView.rating) as String

        
        reviewTextView.text = "How was your experience?"
        reviewTextView.textColor = UIColor.lightGray
        reviewTextView.delegate = self
        
        reviewScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 750)
        self.hideKeyboardWhenTappedAround()


    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    performSegue(withIdentifier: "openSearch", sender: self)
    return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        postButton.isEnabled = true
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if (locationTextField.text?.isEmpty == false){
            postButton.isEnabled = true
        }else{
            postButton.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "How was your experience?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        postButton.isEnabled = true


    }
    
    

    func postReview(){
        
        if (locationTextField.text?.isEmpty == false) && (reviewTextView.text.isEmpty == false){
            let location = locationTextField.text
            let rating = liveLabel.text
            let rev = reviewTextView.text
            
            PostService.createReview(rating: rating!, location: location!, review: rev!)
        }else{
            postButton.isEnabled = false
        }
        
        
    }
   
    func disablePost(){
        if (locationTextField.text?.isEmpty)! {
            postButton.isEnabled = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating:Float) {
        self.liveLabel.text = NSString(format: "%.2f", self.ratingView.rating) as String
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
