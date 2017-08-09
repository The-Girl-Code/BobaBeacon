//
//  LocationViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/27/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//


import UIKit
import Firebase

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet var tableView: UITableView!
    
    var dataPassed : String?

    var allPlaces : [Place] = []
    
    struct Place {
        var name = String()
        var address = String()
    }
    
    func appendPlaces() -> [Place]{
        var places : [Place] = []
        Database.database().reference().child("places").observeSingleEvent(of: .value, with: { (snapshot) in
            let count = snapshot.childrenCount
            for i in 1...count {
                let place = snapshot.childSnapshot(forPath: String(i))
                
                let name = place.childSnapshot(forPath: "placeName")
                var nameString = String(describing: name)
                let nameIndex = nameString.index(nameString.startIndex, offsetBy: 17)
                nameString = nameString.substring(from: nameIndex)
                
                let address = place.childSnapshot(forPath: "address")
                var addressString = String(describing: address)
                let addressIndex = addressString.index(addressString.startIndex, offsetBy: 15)
                addressString = addressString.substring(from: addressIndex)
                
                places.append(Place(name: nameString, address: addressString))
                
            }
            self.allPlaces = places
            self.filteredPlaces = self.allPlaces
            self.tableView.reloadData()
        })
        return places
    }
        

    var filteredPlaces = [Place]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allPlaces = appendPlaces()
//        placeAddresses = appendAddresses()
        
        filteredPlaces = allPlaces
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredPlaces = allPlaces
        } else {
            // Filter the results
            filteredPlaces = allPlaces.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.filteredPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.filteredPlaces[indexPath.row].name
        cell.detailTextLabel?.text = self.filteredPlaces[indexPath.row].address
        
        
        return cell
    }
    
    deinit {
        self.searchController.view.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! UITableViewCell
        
        dataPassed = (currentCell.textLabel!.text)!
        performSegue(withIdentifier: "unwindToReview", sender: currentCell)
        
        
    }
    
}

