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


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
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
    
    @IBOutlet weak var menuButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(UserDefaults.standard.bool(forKey: "isFirstTime") != true){
            UserDefaults.standard.set(true, forKey: "isFirstTime")
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
        
        
      /*  let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
        let newLoc = NSManagedObject(entity: entity!, insertInto: context) as! Location
        newLoc.windE = false
        newLoc.windN = false
        newLoc.windS = true
        newLoc.windW = false
        newLoc.windSW = true
        newLoc.windNW = false
        newLoc.windSE = false
        newLoc.windNE = false
        newLoc.type = "Buoy"
        newLoc.country = "HR"
        newLoc.city = "Zadar"
        newLoc.latitude = 44.27
        newLoc.longitude = 14.7682
        newLoc.locDescription = "Ist is a Buoy close to Zadar."
        newLoc.island = "Ist"
        newLoc.name = "Ist"
        newLoc.depth = 4.0
        do {
            try context.save()
            print("saved")
        } catch {
            print("Failed saving")
        }*/
        
      /*  UISearchBar *sera = [[UISearchBar alloc] init];
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 220 , 44);
        [view addSubview:sera];
        //view.backgroundColor = [UIColor colorWithRed:97/255.0 green:175/255.0 blue:222/255.0 alpha:1.0];
        // view.layer.cornerRadius = 8.0;
        view.clipsToBounds = NO;
        sera.placeholder = @"Current Location";
        //sera.backgroundColor = [UIColor yellowColor];
        sera.frame = CGRectMake(0, 5, view.frame.size.width, 34);
        sera.layer.borderColor =  [UIColor colorWithRed:18/255.0 green:165/255.0 blue:244/255.0 alpha:1.0].CGColor;
        sera.layer.borderWidth = 2.0;
        sera.layer.cornerRadius = 17.0;*/


        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.returnsObjectsAsFaults = false
        do {
            locationArray = try context.fetch(request) as! Array<Location>
            for data in locationArray as [NSManagedObject] {
               // print(data.value(forKey: "name") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
        
        for location in locationArray {
            let annotation = CustomAnnotation(coordinate:  CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            annotation.title = location.name
            annotation.type = location.type
            mapView.addAnnotation(annotation)
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
        //    [_locationField resignFirstResponder];
         //   [_notesTextView resignFirstResponder];
            self.view.alpha = 0.5;
            self.view.isUserInteractionEnabled = false;
        }
        isSideMenuOpened = !isSideMenuOpened;
        self.revealViewController().revealToggle(sender)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // Not getting called
        let span = MKCoordinateSpanMake(5, 5)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

          print("location update")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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
        default:
            break
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
            
//            if((annotation as! CustomAnnotation).type == "marina") {
//                        print("----------------------------------------")
//                annotationView?.image = UIImage(named : "bouy")
//                    }
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            if((annotation as! CustomAnnotation).type == "marina") {
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
          
        }
//        else {
//            if annotationView == nil {
//                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//                annotationView?.canShowCallout = true
//            } else {
//                annotationView?.annotation = annotation
//            }
//            annotationView?.image = UIImage(named: "mapMarker")
//        }
//
        return annotationView

    }

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
        
//        if let city = placemark.locality,
//            let state = placemark.administrativeArea {
//            annotation.subtitle = "\(city) \(state)"
//        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}
