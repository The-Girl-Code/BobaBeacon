//
//  BBPhotoHelper.swift
//  BobaBeacon
//
//  Created by Aditi Gnanasekar on 7/24/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit

class BBPhotoHelper: NSObject {

        var completionHandler: ((UIImage) -> Void)?

        
        func presentActionSheet(from viewController: UIViewController) {
            
            let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { [unowned self] action in
                   // self.presentImagePickerController(with: .camera, from: viewController)
                })
                
                alertController.addAction(capturePhotoAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: { [unowned self] action in
                   // self.presentImagePickerController(with: .photoLibrary, from: viewController)
                })
                
                alertController.addAction(uploadAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            

            viewController.present(alertController, animated: true)
        }

    }


