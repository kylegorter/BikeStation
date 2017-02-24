//
//  ViewController.swift
//  BikeStation
//
//  Created by Kyle Gorter on 2/24/17.
//  Copyright © 2017 Kyle Gorter. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit
import CoreFoundation

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            
            tableView.delegate = self
            tableView.dataSource = self
            
        }
    }
    
    
    let locationManager = CLLocationManager() // CLLocationManager is a class thus will use '='
    
    var currentLocationAnno: MKAnnotation! // MKAnnotation is a protocol thus will use ':'
    
    var stations = [BikeStation]()
    
    var allStations = [BikeStation]()
    
    // Alternate method to define arrays
    var altStations: [BikeStation] = []
    
    var savedIndex = -1
    
    let search = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.definesPresentationContext = true
        definesPresentationContext = true
        search.hidesNavigationBarDuringPresentation = false
        search.dimsBackgroundDuringPresentation = false
        
        
        
        
        navigationItem.titleView = search.searchBar
        
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func fetchData(){
        let url = "https://feeds.citibikenyc.com/stations/stations.json"
        Alamofire.request(url).responseJSON(completionHandler: {(response) in
            switch response.result {
            case .success(let responseValue):
                let json = JSON(responseValue)
                for (key,subJson) : (String ,JSON) in json{
                    if key == "stationBeanList"{
                        for (_,subsubJson) : (String ,JSON) in subJson{
                            let json = BikeStation(json: subsubJson)
                            
                            self.receiveRoute(sourceLocation: self.currentLocationAnno.coordinate, station: json)
                            
                        }
                        
                    }
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        })
        
    }
    
    

    func receiveRoute(sourceLocation: CLLocationCoordinate2D, station: BikeStation) {
        
        let startPlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        
        let finalPlacemark = MKPlacemark(coordinate: station.coordinate(), addressDictionary: nil)
        
        let startMapItem = MKMapItem(placemark: startPlacemark)
        
        let finalMapItem = MKMapItem(placemark: finalPlacemark)
        
        let requestDirection = MKDirectionsRequest()
        requestDirection.source = startMapItem
        requestDirection.destination = finalMapItem
        requestDirection.transportType = .automobile
        
        let directions = MKDirections(request: requestDirection)
        directions.calculate { (response, error) in
            if let response = response {
                if let route = response.routes.first {
                    station.route = route
                    self.stations.append(station)
                    
                }
                
            }
          
            self.allStations = self.stations
            self.tableView.reloadData()
            
        }
        
    }

    func searchController(searchText: String) {
        
        stations = []
        
        if searchText == "" {
            
            stations = allStations
        } else {
            
            stations = allStations.filter { temp in
                return (temp.stationName.lowercased().contains(searchText.lowercased()))
        }
        
        tableView.reloadData()
    }
    
}
}

extension ViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar) {
    
        searchController(searchText: searchBar.text!)
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            else {
                return UITableViewCell()
        }
        
        let indexStations = stations[indexPath.row]
        
        cell.textLabel?.text = indexStations.stationName
        let distance = String(format: "%0.3f", indexStations.route.distance/1000)
        cell.detailTextLabel?.text = "Available bikes: \(indexStations.availableBikes)" + "Distance: \(distance)KM"
        // More data to be included
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        letSelectedRow =
    }
    
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for search: UISearchController) {
        
        let searchBar = search.searchBar
        
        searchController(searchText: search.searchBar.text!)
    }

}

extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Locating")
            if location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000 {
                
                locationManager.stopUpdatingLocation()
                
                currentLocationAnno = MKPointAnnotation()
//                currentLocationAnno.coordinate = location.coordinate
                
            }
    }
        
    
    
}
}




