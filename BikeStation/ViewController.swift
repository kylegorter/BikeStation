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
    
    
    let locationManager = CLLocationManager()
    
    var currentLocationAnno = MKAnnotation!.self
    
    var stations = [BikeStation]()
    
    var allStations = [BikeStation]()
    
    // Alternate method to define arrays
    var altStations: [BikeStation] = []
    
    var savedIndex = -1
    
    let search = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = search.searchBar
        
//        search.searchResultsUpdater = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchFilter(searchText: String) {
        
        stations = []
        
        if searchText == "" {
            stations = allStations
            
        } else {
            return
            
            
        }
        
    }


}

extension ViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchController) {
        
        
    }

    
    
    
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            else {
                return UITableViewCell()
        }
        
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
        
        
    }

}





