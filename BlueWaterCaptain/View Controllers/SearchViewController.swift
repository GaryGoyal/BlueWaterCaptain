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
import FBAnnotationClusteringSwift

protocol HandleMapSearch {
    func dropNewLocationPin(placemark:MKPlacemark)
     func dropLocationPin(location: Location)
}

class SearchViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, AnnotationViewDoubleTappedDelegate {


    var isSideMenuOpened = false
    var revealViewController1 : SWRevealViewController!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var locationArray :Array<Location>!
    var  filteredArray :Array<Location>!
    var isUserLocationUpdated = false
    var selectedLocation : Location!
    var selectedAnnotation : FBAnnotation!
   let clusteringManager = FBClusteringManager()
    

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

    }
    
    func dropPinsOnMap() {
        filteredArray = locationArray.filter() { (UserDefaults.standard.object(forKey: "types") as! [String]).contains(($0.type?.type!)!) && ($0.depth?.depth)! >=  UserDefaults.standard.double(forKey: "depthValue") }
        let windFilter : Array<Int16> = UserDefaults.standard.object(forKey: "windDirFilter") as! Array<Int16>
        for i in 0..<windFilter.count {
            if(windFilter[i] == 1) {
                switch (i) {
                    
                case 0:
                    filteredArray = filteredArray.filter({$0.windSE?.windSE == 1})
                case 1:
                    filteredArray = filteredArray.filter({$0.windS?.windS == 1})
                case 2:
                    filteredArray = filteredArray.filter({$0.windSW?.windSW == 1})
                case 3:
                    filteredArray = filteredArray.filter({$0.windW?.windW == 1})
                case 4:
                    filteredArray = filteredArray.filter({$0.windNW?.windNW == 1})
                case 5:
                    filteredArray = filteredArray.filter({$0.windN?.windN == 1})
                case 6:
                    filteredArray = filteredArray.filter({$0.windNE?.windNE == 1})
                case 7:
                    filteredArray = filteredArray.filter({$0.windE?.windE == 1})
                default :
                    break
                    
                }
                
            }
        }

        var array:[FBAnnotation] = []
        print(filteredArray.count)
        for i in 0..<filteredArray.count {
            let location = filteredArray[i]
            let annotation = FBAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: (location.coordinates?.latitude)!, longitude: (location.coordinates?.longitude)!)
            if(location.name?.name?.count == 0) {
                annotation.title = " "
            }
            else {
                annotation.title = location.name?.name
            }
            annotation.type = location.type?.type
            annotation.locIndex = i
            array.append(annotation)
        }
        clusteringManager.add(annotations: array)
        self.mapView(mapView, regionDidChangeAnimated: true)
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsObjectsAsFaults = false
        do {
            locationArray = try context.fetch(request) as! Array<Location>
          //  mapView.removeAnnotations(mapView.annotations)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.clusteringManager.removeAll()
                self.dropPinsOnMap()
            })
            
        } catch {
            
            print("Failed")
        }
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark - Open Side Menu
    
    @IBAction func openSideMenu(_ sender : Any) {
        
        let center = mapView.centerCoordinate
        if (isSideMenuOpened) {
            self.view.alpha = 1.0;
            self.view.isUserInteractionEnabled = true;

        }
        else {
            self.view.alpha = 0.5;
            self.view.isUserInteractionEnabled = false;
            UserDefaults.standard.set(center.latitude.roundToDecimal(6), forKey: "centerLat")
            UserDefaults.standard.set(center.longitude.roundToDecimal(6), forKey: "centerLong")
            UserDefaults.standard.synchronize()
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
    
        func createNewLocation(_ currentAnnotation : FBAnnotation) {
            selectedAnnotation = currentAnnotation
           performSegue(withIdentifier: "addSegue", sender: self)
        }
    
    // MARK: - Map View delegates
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
     //   if(!isUserLocationUpdated) {
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
           //  let region  = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
            mapView.setRegion(region, animated: true)
            isUserLocationUpdated = true
      //  }
    }
    

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let mapBoundsWidth = Double(mapView.bounds.size.width)
        DispatchQueue.global(qos: .userInitiated).async {
            let mapRectWidth = mapView.visibleMapRect.size.width
            let scale = mapBoundsWidth / mapRectWidth
            
            let annotationArray = self.clusteringManager.clusteredAnnotations(withinMapRect: mapView.visibleMapRect, zoomScale:scale)
            
            DispatchQueue.main.async {
                self.clusteringManager.display(annotations: annotationArray, onMapView:self.mapView)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if(annotation is MKUserLocation) {
            return nil
        }
        
        var reuseId = ""
        if annotation is FBAnnotationCluster {
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            if clusterView == nil {
                clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, configuration: FBAnnotationClusterViewConfiguration.default())
            } else {
                clusterView?.annotation = annotation
            }
            return clusterView
        }
        else {
            reuseId = "Pin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) //as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            (annotationView as! LocationAnnotationView).delegate = self
            if((annotation as! FBAnnotation).type == "Marina") {
                annotationView?.image = UIImage(named: "marina")
                (annotationView as! LocationAnnotationView).type = "Marina"
            }
            else if ((annotation as! FBAnnotation).type == "Buoy") {
                annotationView?.image = UIImage(named: "bouy")
                (annotationView as! LocationAnnotationView).type = "Buoy"
            }
            else if ((annotation as! FBAnnotation).type == "Anchorage") {
                annotationView?.image = UIImage(named: "anchor")
                (annotationView as! LocationAnnotationView).type = "Anchorage"
            }
            else {
                annotationView?.image = UIImage(named: "mapMarker")
                (annotationView as! LocationAnnotationView).type = "New"
            }
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
            if((annotationView as! LocationAnnotationView).type != "New")  {
                (annotationView as! LocationAnnotationView).location = filteredArray[(annotation as! FBAnnotation).locIndex!]
            }
            else {
                (annotationView as! LocationAnnotationView).location = nil
            }
            return annotationView
        }
    }
    
    
  /*  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
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
        
    }*/
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if ((view as! LocationAnnotationView).type != "New") {
            selectedLocation = (view as! LocationAnnotationView).location
            print(selectedLocation)
            performSegue(withIdentifier: "detailsSegue", sender: self)
        }
        else {
            selectedAnnotation = view.annotation as! FBAnnotation
           performSegue(withIdentifier: "addSegue", sender: self)
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
        else if segue.identifier == "addSegue" {
            let addNav = segue.destination as? UINavigationController
            let  addVC = addNav?.viewControllers.first as! AddEditViewController
            addVC.newAnnotation = selectedAnnotation
            addVC.isFromSideMenu = false
            addVC.isNewLocation = true
        }
    }
    
    @IBAction func unwindToSearchViewController(segue: UIStoryboardSegue) {
//        print("Unwind to Root View Controller")
//      //  mapView.removeAnnotations(mapView.annotations)
//        //dropPinsOnMap()
//        let span = MKCoordinateSpanMake(5, 5)
//        let region = MKCoordinateRegion(center: mapView.centerCoordinate, span: span)
//        mapView.setRegion(region, animated: true)
//        self.mapView(mapView, regionDidChangeAnimated: true)
    }
    
    
}

extension SearchViewController: HandleMapSearch {
    func dropNewLocationPin(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        // mapView.removeAnnotations(mapView.annotations)
        let annotation = FBAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: placemark.coordinate.latitude.roundToDecimal(6), longitude: placemark.coordinate.longitude.roundToDecimal(6))
        annotation.title = placemark.name
        annotation.type = "New"
      //  annotation.location = nil
        mapView.addAnnotation(annotation)
        clusteringManager.add(annotations: [annotation])
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegionMake(placemark.coordinate, span)
          let region  = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func dropLocationPin(location: Location){
        let coordinates = CLLocationCoordinate2D(latitude: (location.coordinates?.latitude)!, longitude: (location.coordinates?.longitude)!)
         let region  = MKCoordinateRegionMakeWithDistance(coordinates, 1000, 1000)
       //  let region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.05, 0.05))
        mapView.setRegion(region, animated: true)
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

