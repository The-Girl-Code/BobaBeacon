//
//  CreateUsernameViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/20/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else {return}
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            
            User.setCurrent(user, writeToUserDefaults: true)
            
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
            if let initialViewController = storyboard.instantiateInitialViewController(){
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
                
            }
            
        }
        
        textFieldShouldReturn()
    }
    
    func textFieldShouldReturn() -> Bool {
        self.usernameTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //testing github
        //more tests
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
