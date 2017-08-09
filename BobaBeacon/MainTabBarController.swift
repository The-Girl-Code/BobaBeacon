//
//  MainTabBarController.swift
//  BobaBeacon
//
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit

extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

class MainTabBarController: UITabBarController {
    
    let photoHelper = PostViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            PostService.create(for: image)
        }
        
        

        
        delegate = self as! UITabBarControllerDelegate
        
        self.tabBar.unselectedItemTintColor = UIColor(red:0.87, green:0.85, blue:1.00, alpha:1.0)        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Sets the default color of the icon of the selected UITabBarItem and Title
        self.tabBar.tintColor = UIColor(red:0.82, green:0.90, blue:0.67, alpha:1.0)
        
        // Sets the default color of the background of the UITabBar
      //  UITabBar.appearance().barTintColor = UIColor.white
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
//UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(color: UIColor.white, size: CGSize(width: tabBar.frame.width/5, height: tabBar.frame.height))
        
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

