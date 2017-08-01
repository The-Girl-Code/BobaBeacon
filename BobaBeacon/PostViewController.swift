//
//  PostViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/20/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
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
        let alertController = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        // 2
        
        let reviewAction = UIAlertAction(title: "Write a review", style: .default, handler: {
            action in
            
            let storyboard = UIStoryboard(name: "Add", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as! ReviewViewController
            viewController.present(vc, animated: true, completion: nil)
        })
        
        alertController.addAction(reviewAction)
        
        let recommendationAction = UIAlertAction(title: "Write a recommendation", style: .default, handler: {
            action in
            
            let storyboard = UIStoryboard(name: "Add", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RecommendationViewController") as! RecommendationViewController
            viewController.present(vc, animated: true, completion: nil)
            
            

        })
        
        alertController.addAction(recommendationAction)
        
    
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                
                self.presentImagePickerController(with: .camera, from: viewController)
            })

            alertController.addAction(capturePhotoAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload Photo", style: .default, handler: { action in
                self.presentImagePickerController(with: .photoLibrary, from: viewController)
            })

            alertController.addAction(uploadAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func presentImagePickerController(with sourceType: UIImagePickerControllerSourceType, from viewController: UIViewController) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        viewController.present(imagePickerController, animated: true)
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


extension PostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            completionHandler?(selectedImage)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
