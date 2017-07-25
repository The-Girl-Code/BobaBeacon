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

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
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
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
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
