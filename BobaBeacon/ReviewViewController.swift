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


class ReviewViewController: UIViewController, FloatRatingViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var liveLabel: UILabel!
    
    
    @IBOutlet weak var locationTextField: UITextField!
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        print("cancel button tapped")
         self.performSegue(withIdentifier: "unwindToFeed", sender: self)
    }

    @IBAction func unwindToReview(segue: UIStoryboardSegue){
        if let sourceViewController = segue.source as? LocationViewController {
            dataRecieved = sourceViewController.dataPassed
        }
    }
    
    var dataRecieved: String? {
        willSet {
            locationTextField.text = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.delegate = self

        
        self.ratingView.emptyImage = UIImage(named: "StarEmpty")
        self.ratingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 1
        self.ratingView.rating = 2.5
        self.ratingView.editable = true
        self.ratingView.halfRatings = true
        self.ratingView.floatRatings = false
        
        self.liveLabel.text = NSString(format: "%.2f", self.ratingView.rating) as String

    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
    performSegue(withIdentifier: "openSearch", sender: self)
    
    return false
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
