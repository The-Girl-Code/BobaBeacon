//
//  RecommendationViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/24/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit

class RecommendationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var storeTextField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    

    @IBOutlet weak var bobaImage: UIButton!
    @IBOutlet weak var drinkLabel: UILabel!
    
    @IBAction func unwindFromCancel(segue: UIStoryboardSegue){
        
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
        
        textView.text = "Write a short description about your favorite flavor here..."
        textView.textColor = UIColor.lightGray

        storeTextField.delegate = self
        textView.delegate = self
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        performSegue(withIdentifier: "toStores", sender: self)
        
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write a short description about your favorite flavor here..."
            textView.textColor = UIColor.lightGray
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
