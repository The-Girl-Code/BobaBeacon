//
//  ReviewViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/24/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit
import FloatRatingView
import Former

class ReviewViewController: FormViewController, FloatRatingViewDelegate {
    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    @IBOutlet weak var liveLabel: UILabel!
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        print("cancel button tapped")
         self.performSegue(withIdentifier: "unwindToFeed", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratingView.emptyImage = UIImage(named: "StarEmpty")
        self.ratingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.ratingView.delegate = self
        self.ratingView.contentMode = UIViewContentMode.scaleAspectFit
        self.ratingView.maxRating = 5
        self.ratingView.minRating = 1
        self.ratingView.rating = 2.5
        self.ratingView.editable = true
        self.ratingView.halfRatings = true
        self.ratingView.floatRatings = false
        
        self.liveLabel.text = NSString(format: "%.2f", self.ratingView.rating) as String


//        let labelRow = LabelRowFormer<FormLabelCell>()
//            .configure { row in
//                row.text = "Label Cell"
//            }.onSelected { row in
//                // Do Something
//        }
//        //labelRow.constraint(equalTo: self.widthAnchor, multiplier: 2.0).isActive = true
//        let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
//            $0.titleLabel.text = "Inline Picker Cell"
//            }.configure { row in
//                row.pickerItems = (1...5).map {
//                    InlinePickerItem(title: "Option\($0)", value: Int($0))
//                }
//            }.onValueChanged { item in
//                // Do Something
//        }
//        let header = LabelViewFormer<FormLabelHeaderView>() { view in
//            view.titleLabel.text = "Label Header"
//        }
//        let section = SectionFormer(rowFormer: labelRow, inlinePickerRow)
//            .set(headerViewFormer: header)
//        former.append(sectionFormer: section)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating:Float) {
        self.liveLabel.text = NSString(format: "%.2f", self.ratingView.rating) as String
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
