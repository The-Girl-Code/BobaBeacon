//
//  TermsAndConditionsViewController.swift
//  BobaBeacon
//
//  Created by Kodo on 8/20/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {

    
    @IBOutlet weak var termsText: UITextView!
    
    @IBAction func acceptButton(_ sender: UIButton) {
        
    }
    
    @IBAction func declineButton(_ sender: Any) {
        let okAlert = UIAlertController(title: nil, message: "You must agree to the Terms and Conditions in order to use BobaBeacon.", preferredStyle: .alert)
                okAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(okAlert, animated: true)
                self.present(LoginViewController(), animated: true) {
                    
        }
            
        
    
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
