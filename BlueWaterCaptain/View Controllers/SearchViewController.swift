//
//  SearchViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/26/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData
//import FBClusteringManager

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
     func dropLocationPin(location: Location)
}

class SearchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var isSideMenuOpened = false;
    var revealViewController : SWRevealViewController!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var locationArray :Array<Location>!
    var isUserLocationUpdated = false
   //let clusteringManager = FBClusteringManager()

    @IBOutlet weak var menuButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("use default venice")
            case .authorizedAlways, .authorizedWhenInUse:
                print("use current location")
            }
        } else {
            print("use default venice")
        }

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
      
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Current Location"
        searchBar.layer.borderColor =  UIColor.init(red: 18/255.0, green: 165/255.0, blue: 244/255.0, alpha: 1.0).cgColor
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsObjectsAsFaults = false
        do {
            locationArray = try context.fetch(request) as! Array<Location>
            for location in locationArray {
                let annotation = CustomAnnotation(coordinate:  CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                annotation.title = location.name
                annotation.type = location.type
                mapView.addAnnotation(annotation)
            }
            
        } catch {
            
            print("Failed")
        }
        
      

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark - Open Side Menu
    
    @IBAction func openSideMenu(_ sender : Any) {
   /*     if (isSideMenuOpened) {
            self.view.alpha = 1.0;
            self.view.isUserInteractionEnabled = true;
        }
        else {
            self.view.alpha = 0.5;
            self.view.isUserInteractionEnabled = false;
        }
        isSideMenuOpened = !isSideMenuOpened;*/
        self.revealViewController().revealToggle(sender)
    }
    
    // MARK: - Map View delegates
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // Not getting called
       // print("location updated")
        if(!isUserLocationUpdated) {
            let span = MKCoordinateSpanMake(5, 5)
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            isUserLocationUpdated = true
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        //        if !(annotation is MKPointAnnotation) {
        //            return nil
        //        }
        
        if(annotation is MKUserLocation) {
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        
        if  (annotation is CustomAnnotation) {
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            if((annotation as! CustomAnnotation).type == "Marina") {
                annotationView?.image = UIImage(named: "marina")
            }
            else if ((annotation as! CustomAnnotation).type == "Buoy") {
                annotationView?.image = UIImage(named: "bouy")
            }
            else if ((annotation as! CustomAnnotation).type == "Anchorage") {
                annotationView?.image = UIImage(named: "anchor")
            }
            else {
                annotationView?.image = UIImage(named: "mapMarker")
            }
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            
        }
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Open add edit")
    }
    
    // MARK: - Location manager delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let location = locations.first else { return }

        //  print("location update")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
  /*  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            //manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            
            
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }*/

    
    
    
}

extension SearchViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        // mapView.removeAnnotations(mapView.annotations)
        let annotation = CustomAnnotation(coordinate: placemark.coordinate)
        annotation.title = placemark.name
        annotation.type = "new"
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func dropLocationPin(location: Location){
        let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let annotation = CustomAnnotation(coordinate:  coordinates)
        annotation.title = location.name
        annotation.type = location.type
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(coordinates, span)
        mapView.setRegion(region, animated: true)
    }
}
