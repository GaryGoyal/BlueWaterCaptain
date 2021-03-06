//
//  LocationSearchTable.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/26/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class LocationSearchTable: UITableViewController {

    var matchingItems = [MKLocalSearchCompletion]()
    var matchingLocalItems:[Location] = []
    var mapView: MKMapView? = nil
    var handleMapSearchDelegate:HandleMapSearch? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     var searchCompleter = MKLocalSearchCompleter()
    var waitIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
        
        waitIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

        waitIndicator.center = CGPoint(x: view.center.x, y : view.center.y - 200)
        waitIndicator.hidesWhenStopped = false
        waitIndicator.isHidden = true
        // Call stopAnimating() when need to stop activity indicator
        //myActivityIndicator.stopAnimating()
        
        
        view.addSubview(waitIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Rows \(matchingItems.count + matchingLocalItems.count)")
        if section == 0 {
            return matchingItems.count
        }
        else {
            return matchingLocalItems.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : LocationResultCell
        cell = tableView.dequeueReusableCell(withIdentifier: "LocationResultCell", for: indexPath) as! LocationResultCell
        
        if(indexPath.section == 0) {
          //  let selectedItem = matchingItems[indexPath.row].placemark
            cell.locaName.text = matchingItems[indexPath.row].title
            cell.locIcon.image = UIImage(named : "mapMarker")
            return cell
        }
        else {
            cell.locaName.text = matchingLocalItems[indexPath.row].name?.name
            if(matchingLocalItems[indexPath.row].type?.type == "Marina") {
                cell.locIcon.image = UIImage(named: "marina")
            }
            else if (matchingLocalItems[indexPath.row].type?.type == "Buoy") {
                cell.locIcon.image = UIImage(named: "bouy")
            }
            else if (matchingLocalItems[indexPath.row].type?.type == "Anchorage") {
                cell.locIcon.image = UIImage(named: "anchor")
            }
            else {
                cell.locIcon.image = UIImage(named: "mapMarker")
            }
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if(indexPath.section == 0) {

            let request = MKLocalSearchRequest()
            print(matchingItems[indexPath.row].title)
            request.naturalLanguageQuery = matchingItems[indexPath.row].title
            request.region = (mapView?.region)!
            let search = MKLocalSearch(request: request)
            waitIndicator.startAnimating()
            waitIndicator.isHidden = false
             self.view.isUserInteractionEnabled = false
            search.start { (response, error) in
                guard let response = response else {
                            return
                }
                if(response.mapItems.count > 0) {
                    let selectedItem = response.mapItems.first?.placemark
                    DispatchQueue.main.async {
                        self.waitIndicator.stopAnimating()
                        self.waitIndicator.isHidden = true
                         self.view.isUserInteractionEnabled = true
                        self.handleMapSearchDelegate?.dropNewLocationPin(placemark: selectedItem!)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
         else {
            let selectedItem = matchingLocalItems[indexPath.row]
            handleMapSearchDelegate?.dropLocationPin(location: selectedItem)
            dismiss(animated: true, completion: nil)
        }
    }

}

extension LocationSearchTable : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
        let localRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        localRequest.returnsObjectsAsFaults = false
        //localRequest.predicate = NSPredicate(format: "name BEGINSWITH[c] %@", searchBarText)
        localRequest.predicate = NSPredicate(format: "name.name contains[c] %@", searchBarText)
        do {
            matchingLocalItems = try context.fetch(localRequest) as! Array<Location>
            print(matchingLocalItems)
             self.tableView.reloadData()
            
        } catch {
            
            print("Failed")
        }
        
        searchCompleter.queryFragment = searchBarText
        searchCompleter.filterType = .locationsOnly
        let search = MKLocalSearch(request: request)
      //  print("search started")
       /* search.start { response, _ in
            guard let response = response else {
                //print("Map no Response")
                 //self.matchingItems.removeAll()
              //  self.tableView.reloadData()
                
                return
            }
           // print(print("Map Response  \(self.matchingItems.count)"))
          //  self.matchingItems = response.mapItems
           // self.tableView.reloadData()
        }*/
        search.start { (response, error) in
            
          //  guard let response = response else {return}
         //   guard let item = response.mapItems.first else {return}
            
          //  item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
            //print("Previois Response \(response?.mapItems.count)")
        }
    }
    
}

extension LocationSearchTable:MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
       // places = completer.results
        
        //delegate?.refreshData()
      //  print(completer.results)
        matchingItems = completer.results
     //   print("Apple Response \(matchingItems.count)")
        self.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        print("\(error.localizedDescription)")
    }
}

