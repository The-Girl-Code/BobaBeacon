//
//  PostActionCell.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/27/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import UIKit

protocol PostActionCellDelegate: class {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell)
}

class PostActionCell: UITableViewCell {
    weak var delegate: PostActionCellDelegate?
    
    static let height: CGFloat = 46
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var displayTime: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        delegate?.didTapLikeButton(sender, on: self)
    }
    
    func doubleTapped() {
        //numberLikes += 1
        //delegate?.didTapLikeButton(likeButton, on: self)
        print("ayyyy")
    }
    
    
}
