////
////  SearchResultsController.swift
////  BobaBeacon
////
////  Created by Anisha Kollareddy on 8/2/17.
////  Copyright © 2017 The Girl Code. All rights reserved.
////
//
//import UIKit
//import SwiftyJSON
//import Alamofire
//import AlamofireImage
//import AlamofireNetworkActivityIndicator
//import GoogleMaps
//
//protocol LocateOnTheMap{
//    func locateWithLongitude(lon:Double, andLatitude lat:Double, andTitle title: String)
//}
//
//class SearchResultsController: UIViewController, LocateOnTheMap {
//
//
//    var searchResultController:SearchResultsController!
//    var resultsArray = [String]()
//    var googleMapsView:GMSMapView!
//    
//    var searchResults: [String]!
//    var delegate: LocateOnTheMap!
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.searchResults = Array()
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        self.googleMapsView =  GMSMapView(frame: self.view.frame)
//        self.view.addSubview(self.googleMapsView)
//        searchResultController = SearchResultsController() as! SearchResultsController
//        searchResultController.delegate = self as! LocateOnTheMap
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return self.searchResults.count
//    }
//
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
//        
//        cell.textLabel?.text = self.searchResults[indexPath.row]
//        return cell
//    }
//    
//
//    /*
//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    */
//
//    /*
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    */
//
//    /*
//    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//
//    }
//    */
//
//    /*
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//    */
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    var json : JSON?
//
//     func tableView(tableView: UITableView,
//                            didSelectRowAtIndexPath indexPath: NSIndexPath){
//        // 1
//        self.dismiss(animated: true, completion: nil)
//        // 2
//        let correctedAddress:String! = self.searchResults[indexPath.row].addingPercentEncoding(withAllowedCharacters: NSCharacterSet.symbols)
//        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(correctedAddress)&sensor=false")
//        
////        let addressString = address.replacingOccurrences(of: " ", with: "+")
////        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(addressString)&key=AIzaSyCqrOwp8IQL05noo4vfdMs0nrDUrv0_jy0"
////        
//        Alamofire.request(url as! URLRequestConvertible).validate().responseJSON() { response in
//            switch response.result {
//            case .success:
//                if let value = response.result.value {
//                    self.json = JSON(value)
//                    let lat = self.json?["results"][0]["geometry"]["location"]["lat"].doubleValue
//                    let lon = self.json?["results"][0]["geometry"]["location"]["lng"].doubleValue
//                    
//                    self.delegate.locateWithLongitude(lon: lon!, andLatitude: lat!, andTitle: self.searchResults[indexPath.row] )
//
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//
//    }
//
//}
