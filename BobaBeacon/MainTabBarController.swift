//
//  MainTabBarController.swift
//  BobaBeacon
//
//  Created by Aditi Gnanasekar on 7/24/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let photoHelper = BBPhotoHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            print("handle image")
        }

    delegate = self
    tabBar.unselectedItemTintColor = .black
        
        }

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
