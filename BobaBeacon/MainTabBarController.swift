//
//  MainTabBarController.swift
//  BobaBeacon
//
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let photoHelper = PostViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            print("handle image")
            PostService.create(for: image)
        }

        
        delegate = self as! UITabBarControllerDelegate
        
        tabBar.unselectedItemTintColor = .black
        // Do any additional setup after loading the view.
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



extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 2 {
            photoHelper.presentActionSheet(from: self)
            return false
            
        }
        return true
    }
}
