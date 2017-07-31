//
//  ViewController.swift
//  BobaBeacon
//
//  Created by TheGirlCode on 7/19/17.
//  Copyright © 2017 TheGirlCode. All rights reserved.
// 

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
import Firebase
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

extension CLLocation {
    //in meteres
    class func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}


class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate  {
    
    let locationManager = CLLocationManager()
    var lastlocation: CLLocation? = nil
    var mapView: GMSMapView? = nil
    var lastPosition: CLLocationCoordinate2D? = nil
    var addPlaceTarget: CLLocationCoordinate2D? = nil
    
    var places : [[String:String]] = []
    
    var json : JSON?
    lazy var geocoder = CLGeocoder()
    

    func appendData() -> [[String : String]] {
        var places = [[String: String]]()
        Database.database().reference().child("places").observeSingleEvent(of: .value, with: { (snapshot) in
            let count = snapshot.childrenCount
            for i in 1...count {
                let place = snapshot.childSnapshot(forPath: String(i))
                let address = place.childSnapshot(forPath: "address")
                var addressString = String(describing: address)
                let addressIndex = addressString.index(addressString.startIndex, offsetBy: 15)
                addressString = addressString.substring(from: addressIndex)
                
                let name = place.childSnapshot(forPath: "placeName")
                var nameString = String(describing: name)
                let nameIndex = nameString.index(nameString.startIndex, offsetBy: 17)
                nameString = nameString.substring(from: nameIndex)
                places.append([addressString: nameString])
                self.getCoordinatesAndUpdateMap(address: addressString, name: nameString)
            }
        })
        return places
    }
    
    
    
    func getCoordinatesAndUpdateMap(address: String, name: String) {

            let addressString = address.replacingOccurrences(of: " ", with: "+")
            let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(addressString)&key=AIzaSyCqrOwp8IQL05noo4vfdMs0nrDUrv0_jy0"

            Alamofire.request(urlString).validate().responseJSON() { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        self.json = JSON(value)
                        let latitude = self.json?["results"][0]["geometry"]["location"]["lat"].doubleValue
                        let longitude = self.json?["results"][0]["geometry"]["location"]["lng"].doubleValue
                        self.updateMarkers(name: name, address: address, location: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!))
                    }
                case .failure(let error):
                    print(error)
                }
            }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.settings.myLocationButton = true
        mapView?.isMyLocationEnabled = true
        if mapView?.isMyLocationEnabled == true{
            print("location is true")
        }else{
            print("location is false")
        }
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //updateMarkers(location: CLLocationCoordinate2D(latitude: 37.381531, longitude: -121.958578))
        places = appendData()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        if(lastlocation == nil || manager.location!.distance(from: lastlocation!) > 508) {
            lastlocation = manager.location
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            mapView?.animate(toLocation: locValue)
           //updateMarkers(location: locValue)
        }
    }
    
    func updateMarkers(name: String, address: String, location: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (location.latitude),longitude: (location.longitude))
        marker.title = "\(name)"
        marker.snippet = "\(address)"
        marker.icon = UIImage(named: "boba3.png")
        marker.map = self.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.393678, longitude: -122.079944, zoom: 14.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView!.isMyLocationEnabled = true
        mapView!.delegate = self
        view = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition){
        if(lastPosition == nil) {
            lastPosition = position.target
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
        if(lastPosition == nil || CLLocation.distance(from:lastPosition!, to: position.target) > 500) {
            lastPosition = position.target
        }
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("You long pressed at \(coordinate.latitude), \(coordinate.longitude)")
        self.addPlaceTarget = coordinate
        //self.performSegue(withIdentifier: "addplace", sender: self)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String,
                 name: String, location: CLLocationCoordinate2D) {
        print("You tapped \(name): \(placeID), \(location.latitude)/\(location.longitude)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

