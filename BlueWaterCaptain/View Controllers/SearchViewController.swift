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
    func dropNewLocationPin(placemark:MKPlacemark)
     func dropLocationPin(location: Location)
}

class SearchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, AnnotationViewDoubleTappedDelegate {


    var isSideMenuOpened = false
    var revealViewController : SWRevealViewController!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var locationArray :Array<Location>!
    var isUserLocationUpdated = false
    var selectedLocation : Location!
   //let clusteringManager = FBClusteringManager()
    

    @IBOutlet weak var menuButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        mapView.layer.borderWidth = 0.5
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
      
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Current Location"
        navigationItem.titleView = resultSearchController?.searchBar
//        navigationItem.titleView?.layer.borderColor =  UIColor.init(red: 18/255.0, green: 165/255.0, blue: 244/255.0, alpha: 1.0).cgColor
//        navigationItem.titleView?.layer.borderWidth = 1
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsObjectsAsFaults = false
        do {
            locationArray = try context.fetch(request) as! Array<Location>
            dropPinsOnMap()
            
        } catch {
            
            print("Failed")
        }
    }
    
    func dropPinsOnMap() {
        let filteredArray = locationArray.filter() { (UserDefaults.standard.object(forKey: "types") as! [String]).contains($0.type!) && $0.depth >  UserDefaults.standard.double(forKey: "depthValue") }
        for location in filteredArray {
            let annotation = CustomAnnotation(coordinate:  CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            annotation.title = location.name
            annotation.type = location.type
            annotation.location = location
            mapView.addAnnotation(annotation)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
               setDefaultLocationOnMap()
            case .authorizedAlways, .authorizedWhenInUse:
                print("use current location")
            }
        } else {
            setDefaultLocationOnMap()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark - Open Side Menu
    
    @IBAction func openSideMenu(_ sender : Any) {
        if (isSideMenuOpened) {
            self.view.alpha = 1.0;
            self.view.isUserInteractionEnabled = true;
        }
        else {
            self.view.alpha = 0.5;
            self.view.isUserInteractionEnabled = false;
        }
        isSideMenuOpened = !isSideMenuOpened;
        self.revealViewController().revealToggle(sender)
    }
    
    func setDefaultLocationOnMap() {
        if(!isUserLocationUpdated) {
            let span = MKCoordinateSpanMake(5, 5)
            let latitude = UserDefaults.standard.value(forKey: "defaultLatitude")
            let longitude = UserDefaults.standard.value(forKey: "defaultLongitude")
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees), span: span)
            //  let region  = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
            mapView.setRegion(region, animated: true)
            isUserLocationUpdated = true
        }
    }
    
    // MARK: - Annotation view delegates
    
    func showTappedAnnotationViewDetails(_ selectedLocation: Location) {
            self.selectedLocation = selectedLocation
            performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
        func createNewLocation() {
            print("create new location")
        }
    
    // MARK: - Map View delegates
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if(!isUserLocationUpdated) {
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
           //  let region  = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
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
                annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
        
            (annotationView as! LocationAnnotationView).delegate = self
            if((annotation as! CustomAnnotation).type == "Marina") {
                annotationView?.image = UIImage(named: "marina")
                (annotationView as! LocationAnnotationView).type = "Marina"
            }
            else if ((annotation as! CustomAnnotation).type == "Buoy") {
                annotationView?.image = UIImage(named: "bouy")
                (annotationView as! LocationAnnotationView).type = "Buoy"
            }
            else if ((annotation as! CustomAnnotation).type == "Anchorage") {
                annotationView?.image = UIImage(named: "anchor")
                (annotationView as! LocationAnnotationView).type = "Anchorage"
            }
            else {
                annotationView?.image = UIImage(named: "mapMarker")
                (annotationView as! LocationAnnotationView).type = "New"
            }
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            if((annotation as! CustomAnnotation).location != nil &&  (annotationView as! LocationAnnotationView).type != "New")  {
                (annotationView as! LocationAnnotationView).location = (annotation as! CustomAnnotation).location
            }
            
        }
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if ((view as! LocationAnnotationView).type != "New") {
            selectedLocation = (view as! LocationAnnotationView).location
            performSegue(withIdentifier: "detailsSegue", sender: self)
        }
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

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailsSegue" {
            let  detailsView = segue.destination as?  DetailsViewController
            detailsView?.selectedLocation = selectedLocation
        }
    }
    
    @IBAction func unwindToSearchViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
        mapView.removeAnnotations(mapView.annotations)
        dropPinsOnMap()
    }
    
    
}

extension SearchViewController: HandleMapSearch {
    func dropNewLocationPin(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        // mapView.removeAnnotations(mapView.annotations)
        let annotation = CustomAnnotation(coordinate: placemark.coordinate)
        annotation.title = placemark.name
        annotation.type = "new"
        annotation.location = nil
        mapView.addAnnotation(annotation)
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegionMake(placemark.coordinate, span)
          let region  = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func dropLocationPin(location: Location){
        let coordinates = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
         let region  = MKCoordinateRegionMakeWithDistance(coordinates, 1000, 1000)
       //  let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.05, 0.05))
        mapView.setRegion(region, animated: true)
    }
}
