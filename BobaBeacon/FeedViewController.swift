//
//  FeedViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/20/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase


let notificationKey = "com.thegirlcode"

class FeedViewController: UIViewController {
    
    var posts = [Post]()
    let refreshControl = UIRefreshControl()
    
    @IBAction func unwindToFeed(segue: UIStoryboardSegue){
        
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        reloadTimeline()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTimeline), name: NSNotification.Name(notificationKey), object: nil)
        
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(didDoubleTap(recognizer:)))
        recognizer.numberOfTapsRequired = 2
        self.tableView.addGestureRecognizer(recognizer)
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.black,
             NSFontAttributeName: UIFont(name: "Avenir", size: 21)!]
        
    }
    
    func didDoubleTap(recognizer: UIGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.ended {
            let swipeLocation = recognizer.location(in: self.tableView)
            if let swipedIndexPath = tableView.indexPathForRow(at: swipeLocation) {
                if let tappedCell = self.tableView.cellForRow(at: swipedIndexPath) as? PostItemCell {
                    guard let indexPath = tableView.indexPath(for: tappedCell)
                        else { return }
                    let post = posts[indexPath.section]
                    
                    LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
                        
                        
                        guard success else { return }
                        post.likeCount += !post.isLiked ? 1 : -1
                        post.isLiked = !post.isLiked
                        self.tableView.reloadData()

                    }


                }
            }
        }
    }
    
    func reloadTimeline() {
   
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    

    
    func configureTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        refreshControl.addTarget(self, action: #selector(reloadTimeline), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func handleOptionsButtonTap(from cell: PostHeaderCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var post = posts[indexPath.section]
        let poster = post.poster
        let ref = Database.database().reference()
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if poster.uid != User.current.uid {
            let flagAction = UIAlertAction(title: "Report as Inappropriate", style: .default) { _ in
                PostService.flag(post)
                
                let okAlert = UIAlertController(title: nil, message: "The post has been flagged.", preferredStyle: .alert)
                okAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(okAlert, animated: true)
            }
            
            alertController.addAction(flagAction)
        }
        if poster.uid == User.current.uid {
            let flagAction = UIAlertAction(title: "Delete Post", style: .default) { _ in
                PostService.flag(post)
                ref.child("posts").child(post.key!).removeValue { error in
                    if error != nil {
                        print("error \(error)")
                    }
                }
                
                let okAlert = UIAlertController(title: nil, message: "This post has been deleted.", preferredStyle: .alert)
                okAlert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(okAlert, animated: true)
            }
            
            alertController.addAction(flagAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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

extension FeedViewController: UITableViewDataSource, UITableViewDelegate, PostActionCellDelegate {
    
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        guard let indexPath = tableView.indexPath(for: cell)
            else { return }
        likeButton.isUserInteractionEnabled = false
        let post = posts[indexPath.section]
        
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in

            defer {
                likeButton.isUserInteractionEnabled = true
            }
            
            guard success else { return }
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell
                else { return }
            
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
    
    func configureCell(_ cell: PostActionCell, with post: Post) {
        cell.displayTime.text = timestampFormatter.string(from: post.creationDate)
        cell.likeButton.isSelected = post.isLiked
        cell.likeCountLabel.text = "\(post.likeCount) likes"
        if cell.likeButton.isSelected {
            cell.likeButton.setImage(UIImage(named: "filled_heart"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "heart_unfilled"), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell", for: indexPath) as! PostHeaderCell
            cell.usernameLabel.text = post.poster.username
            let image = UIImage(named: "Thai")
            cell.profileImageView.image = image
            cell.profileImageView.setRounded()
            cell.didTapOptionsButtonForCell = handleOptionsButtonTap(from:)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostItemCell", for: indexPath) as! PostItemCell
            if post.typeOfPost == "photo"{
                let imageURL = URL(string: post.imageURL)
                cell.postImageView.kf.setImage(with: imageURL)
                cell.postImageView.isHidden = false
                cell.reviewTextView.isHidden = true
                cell.recommendationTextView.isHidden = true
                cell.drinkImage.isHidden = true
            } else if post.typeOfPost == "review"{
                let review = post.review
                let location = post.location
                let rating = post.rating
                cell.reviewTextView.text = "Location:\(location) \nRating: \(rating) \n\n\(review)"
                cell.postImageView.isHidden = true
                cell.reviewTextView.isHidden = false
                cell.recommendationTextView.isHidden = true
                cell.drinkImage.isHidden = true
            } else if post.typeOfPost == "recommendation" {
                let recommendation = post.recommendation
                let location = post.location
                let drink = post.drink
                cell.recommendationTextView.text = "Location:\(location) \nDrink: \(drink) \n\n\(recommendation) "
                cell.drinkImage.image = UIImage(named: drink)
                cell.postImageView.isHidden = true
                cell.reviewTextView.isHidden = true
                cell.recommendationTextView.isHidden = false
                cell.drinkImage.isHidden = false
            }
            
//            let tap = UITapGestureRecognizer(target: self, action: #selector(PostActionCell.doubleTapped))
////            let tap = UITapGestureRecognizer(target: self, action: #selector(self.printSomething))
//            tap.numberOfTapsRequired = 2
////            view.addGestureRecognizer(tap)
//            cell.addGestureRecognizer(tap)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostActionCell", for: indexPath) as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)
            
            return cell
        default:
            fatalError("Error: unexpected indexPath.")
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.section]
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
        case 1:
            var height : CGFloat?
            if post.typeOfPost == "photo" {
                height = post.imageHeight
            }
            else if post.typeOfPost == "review" {
                height = 100
            }
            else if post.typeOfPost == "recommendation" {
                height = 100
            }
            return height!
        case 2:
            return PostActionCell.height
        default: break
            //fatalError()
        }
        return 42
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
}

