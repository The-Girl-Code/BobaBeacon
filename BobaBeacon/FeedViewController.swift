//
//  FeedViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/20/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
//

import UIKit
import Kingfisher


//protocol RefreshFeedDelegate {
//    func reloadData()
//}

let notificationKey = "com.aastha.aditi"

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
    }
    
    func reloadTimeline() {
   
        UserService.posts(for: User.current) { (posts) in
            self.posts = posts
            print(posts.count)
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
//    func reloadData() {
//        reloadTimeline()
//    }
    
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
        print("did tap like button")
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
        print("this is post in table view \(posts)")

        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostHeaderCell", for: indexPath) as! PostHeaderCell
            //cell.usernameLabel.text = User.current.username
            cell.usernameLabel.text = post.poster.username
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostItemCell", for: indexPath) as! PostItemCell
            let imageURL = URL(string: post.imageURL)
            cell.postImageView.kf.setImage(with: imageURL)

            
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
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
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

