//
//  PostViewController.swift
//  BobaBeacon
//
//  Created by Ananya Bhat on 7/20/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Reached Here")
        // Do any additional setup after loading the view.
    }
    
    var completionHandler: ((UIImage) -> Void)?
    
    
    func presentActionSheet(from viewController: UIViewController) {
        // 1
        let alertController = UIAlertController(title: nil, message: "What do you want to post?", preferredStyle: .actionSheet)
        
        // 2
        
        let reviewAction = UIAlertAction(title: "Review", style: .default, handler: {
            action in
            
                //self.dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "Add", bundle: nil)
            //let vc = self
            let vc = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
            viewController.present(vc, animated: true, completion: nil)
        })
        
        alertController.addAction(reviewAction)
        
        let recommendationAction = UIAlertAction(title: "Recommendation", style: .default, handler: {
            action in
            
            let storyboard = UIStoryboard(name: "Add", bundle: nil)
            //let vc = self
            let vc = storyboard.instantiateViewController(withIdentifier: "RecommendationViewController") as! RecommendationViewController
            viewController.present(vc, animated: true, completion: nil)
            
            
//            self.present(RecommendationViewController(), animated: true, completion: {
//                return
//            })
        })
        
        alertController.addAction(recommendationAction)
        
        let photoAction = UIAlertAction(title: "Photo", style: .default, handler: {
            action in
            
            let storyboard = UIStoryboard(name: "Add", bundle: nil)
            //let vc = self
            let vc = storyboard.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
            viewController.present(vc, animated: true, completion: nil)
            
            //self.performSegue(withIdentifier: "toPhoto", sender: self)
            
        })
        
        alertController.addAction(photoAction)
        
        
        
        //        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        //            // 3
        //            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
        //                // do nothing yet...
        //            })
        //
        //            // 4
        //            alertController.addAction(capturePhotoAction)
        //        }
        //
        //        // 5
        //        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        //            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { action in
        //                // do nothing yet...
        //            })
        //
        //            alertController.addAction(uploadAction)
        //        }
        
        // 6
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 7
        viewController.present(alertController, animated: true)
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
