//
//  DetailsViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/30/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
     @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapMarker: UIImageView!
     @IBOutlet weak var imagesView: UIView!
      @IBOutlet weak var changesView: UIView!
     @IBOutlet weak var coordinatesLabel: UILabel!
     @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var islandLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var changesLabel: UILabel!
     @IBOutlet weak var depthLabel: UILabel!
     @IBOutlet weak var navBar: UINavigationBar!
     @IBOutlet weak var imagesViewHeight: NSLayoutConstraint!
     @IBOutlet weak var changesViewHeight: NSLayoutConstraint!
      @IBOutlet weak var depthLabelTop: UILabel!
    var calculationObj = CalculationsAndConversions()
    var selectedLocation : Location!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        mapView.layer.borderWidth = 0.5
        
        let annotation = CustomAnnotation(coordinate:  CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude))
        annotation.title = selectedLocation.name
        annotation.type = selectedLocation.type
        annotation.location = selectedLocation
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude), span: span)
        //  let region  = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
        mapView.setRegion(region, animated: true)
        navBar.topItem?.title = selectedLocation.name
        nameLabel.text = selectedLocation.name
        islandLabel.text = selectedLocation.island! + ", " + selectedLocation.city!
        descLabel.text = selectedLocation.locDescription
        configureLabels()
       // coordinatesLabel.text = String(selectedLocation.latitude) + "°, " + String(selectedLocation.longitude) + "°"
        if(selectedLocation.type == "Marina") {
            mapMarker.image = UIImage(named: "marina")
        }
        else if (selectedLocation.type == "Buoy") {
            mapMarker.image = UIImage(named: "bouy")
        }
        else if (selectedLocation.type == "Anchorage") {
            mapMarker.image = UIImage(named: "anchor")
        }
        else {
            mapMarker.image = UIImage(named: "mapMarker")
        }
        
        let height : CGFloat  = 0.0
        
        print(calculationObj.convertFromDegreeDecimalToDegreeMinutes(selectedLocation.latitude, forType: "latitude"))
        print(calculationObj.convertFromDegreeDecimalToDegreeMinutes(selectedLocation.longitude, forType: "longitude"))
    print(calculationObj.convertFromDegreeDecimalToDegreeMinutesSeconds(selectedLocation.latitude, forType: "latitude"))
  print(calculationObj.convertFromDegreeDecimalToDegreeMinutesSeconds(selectedLocation.longitude, forType: "longitude"))
        
//        changesViewHeight.constant = 0.0
//        changesView.isHidden = true
        
     /*   let count = 10
        var x : CGFloat = 0.0
        var y  : CGFloat = 0.0
        let width = (self.view.frame.width - 30) / 2
        for i in 0...count {
            let img = UIImageView.init(frame: CGRect(x: x, y: y, width: width, height: width))
            img.image = UIImage(named : "background")
            imagesView.addSubview(img)
            x = x + 10.0 + width
            if(i % 2 != 0) {
                y = y + 10.0 + width
                x = 0
            }
            else {
               height = height + 10.0 + width
            }
        }*/
        
        
        imagesViewHeight.constant = height
    }
    
    func configureLabels() {
        
        let coordinateFormat = UserDefaults.standard.value(forKey: "coordinateFormat") as! String
        switch coordinateFormat {
        case "DecDeg":
            coordinatesLabel.text = String(selectedLocation.latitude) + "°, " + String(selectedLocation.longitude) + "°"
            break
        case "DecMin":
            coordinatesLabel.text = calculationObj.convertFromDegreeDecimalToDegreeMinutes(selectedLocation.latitude, forType: "latitude") + ", " + calculationObj.convertFromDegreeDecimalToDegreeMinutes(selectedLocation.longitude, forType: "longitude")
            break
        case "DecMinSec":
            coordinatesLabel.text = calculationObj.convertFromDegreeDecimalToDegreeMinutesSeconds(selectedLocation.latitude, forType: "latitude") + ", " + calculationObj.convertFromDegreeDecimalToDegreeMinutesSeconds(selectedLocation.longitude, forType: "longitude")
            break
        default:
             coordinatesLabel.text = String(selectedLocation.latitude) + "°, " + String(selectedLocation.longitude) + "°"
            break
        }
        
        let depthFormat = UserDefaults.standard.value(forKey: "depthFormat") as! String
        switch depthFormat {
        case "metre":
            depthLabel.text = String(selectedLocation.depth) + " metre"
            depthLabelTop.text = String(selectedLocation.depth) + " m"
            break
        case "km":
            depthLabel.text = String(selectedLocation.depth/1000.0) + " km"
            depthLabelTop.text = String(selectedLocation.depth/1000.0) + " km"
            break
        default:
            depthLabel.text = String(selectedLocation.depth) + " metre"
            depthLabelTop.text = String(selectedLocation.depth/1000.0) + " m"
            break
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editLocation(_ sender : Any) {
        
    }
    
    @IBAction func validateChanges(_ sender : Any) {
        
    }
    
    @IBAction func cancelButtonTapped(_ sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Map View delegates
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if(annotation is MKUserLocation) {
            return nil
        }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        
        if  (annotation is CustomAnnotation) {
            
            if annotationView == nil {
                annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = false
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
            
        }
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Open add edit")
        selectedLocation = (view as! LocationAnnotationView).location
        performSegue(withIdentifier: "detailsSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
