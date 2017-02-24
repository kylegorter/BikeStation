//
//  BikeStation.swift
//  BikeStation
//
//  Created by Kyle Gorter on 2/24/17.
//  Copyright © 2017 Kyle Gorter. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import MapKit
import CoreLocation

class BikeStation {
    
    var id: Int
    
    var latitude: Double
    var longitude: Double
    
    var stationName: String
    var availableBikes: Int
    
    var annotation: MKPointAnnotation!
    
    var route = MKRoute()
    
    
    
    
    
    init (json: JSON) {
        self.id = json["id"].int ?? 0
        
        self.latitude = json["latitude"].double ?? 0
        self.longitude = json["longitude"].double ?? 0
        
        self.stationName = json["stationName"].string ?? ""
        self.availableBikes = json["availableBikes"].int ?? 0
        
        annotation = MKPointAnnotation()
        annotation.coordinate = self.coordinate()
        annotation.title = stationName
        annotation.subtitle = "Available Bikes: \(availableBikes)"
        
        
        
        
    }
    
    func coordinate() -> CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
    }
    
    
}
