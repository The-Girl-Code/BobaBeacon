//
//  BobaPlace.swift
//  BobaBeacon
//
//  Created by Kodo on 7/20/17.
//  Copyright © 2017 The Girl Code. All rights reserved.
//

import Parse
import CoreLocation


extension BobaPlace: PFSubclassing {
    class func parseClassName() -> String {
        return "BobaPlaces"
    }
    
    override class func initialize() {
        
    }
}

class BobaPlace: PFObject {
    
    @NSManaged var Name: String?
    @NSManaged var Address: String?
    @NSManaged var City: String?
    @NSManaged var State: String?
    @NSManaged var Zip: String?
    @NSManaged var location: PFGeoPoint?
    
    let justOnce: () = {
        BobaPlace.registerSubclass()
    }()
    
    override class func query() -> PFQuery<PFObject>? {
        let query = PFQuery(className: BobaPlace.parseClassName())
        return query
    }
    
    init(Name: String, Address: String?, City: String?, State: String?, Zip: String?){
        super.init()
        
        self.Name = Name
        self.Address = Address
        self.City = City
        self.State = State
        self.Zip = Zip
    }
    
    func updateLocation()  {
        let address : String = self.Address! + ", " + self.City! + ", " + self.State!
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            if (error == nil) && (placemarks?.count)! > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                self.location = PFGeoPoint(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
                //print(location)
                self.saveInBackground()
            }
        }
    }
    
    class func nearByPlaces(location: PFGeoPoint, block: @escaping ([BobaPlace]?, Error?) -> Void) {
        let query = BobaPlace.query()!
        query.whereKey("location", nearGeoPoint: location, withinMiles: 2.0)
        query.findObjectsInBackground { objects, error in
            if let places = objects as? [BobaPlace] {
                block(places, error)
            }else {
                block(nil, error)
            }
        }
    }
    
    override init() {
        super.init()
    }
}
