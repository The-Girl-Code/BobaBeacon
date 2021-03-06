//
//  LoginViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/20/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import Firebase


typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var gifView: UIImageView!
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
        authUI.delegate = self
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gifView.loadGif(name: "BOBAGIFFF4")
        //gifView.image = UIImage(named: "boba-login")
        //testing github
        //more tests
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?){
        if let error = error{
            //assertionFailure("Error signing in: \(error.localizedDescription)")
        }
        
        guard let user = user
            else {return}
        UserService.show(forUID: user.uid) { (user) in
            if let user = user {
                // handle existing user
                User.setCurrent(user, writeToUserDefaults: true)
                
                let initialViewController = UIStoryboard.initialViewController(for: .main)
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }else{
                
                self.performSegue(withIdentifier: "toTermsAndConditions", sender: self)
            }
        }
    }
}
