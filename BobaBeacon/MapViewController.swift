//
//  ViewController.swift
//  BobaBeacon
//
//  Created by Kodo on 7/19/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//  hello

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        if(lastlocation == nil || manager.location!.distance(from: lastlocation!) > 508) {
            lastlocation = manager.location
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            mapView?.animate(toLocation: locValue)
           updateMarkers(location: locValue)
        }
    }
    
    func updateMarkers(location: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.381531, longitude: -121.958578)
        marker.title = "Hacker Dojo"
        marker.snippet = "Santa Clara"
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if segue.identifier == "addplace" {
//            let apc = segue.destination as! AddPlaceController
//            apc.coordinate = self.addPlaceTarget
//        }
//    }
}

