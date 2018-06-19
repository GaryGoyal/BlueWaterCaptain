//
//  DetailsViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/30/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import FBAnnotationClusteringSwift

class DetailsViewController: UIViewController, MKMapViewDelegate {
    
    
     @IBOutlet weak var arcView : ArcView!
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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedLocation : Location!
    var imagesArray = [Images]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        mapView.layer.borderWidth = 0.5
        configureView()
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func configureView() {

        mapView.removeAnnotations(mapView.annotations)
        let annotation = FBAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude)
        annotation.title = selectedLocation.name
        annotation.type = selectedLocation.type
        //annotation.location = selectedLocation
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: selectedLocation.latitude, longitude: selectedLocation.longitude), span: span)
        //  let region  = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
        mapView.setRegion(region, animated: true)
        navBar.topItem?.title = selectedLocation.name
        if((selectedLocation.name?.count)! > 0) {
            nameLabel.text = selectedLocation.name
        }
        else {
            nameLabel.text = " "
        }
        if((selectedLocation.island?.count)! == 0 && (selectedLocation.city?.count)! == 0) {
            islandLabel.text = " "
        }
        else {
            islandLabel.text = selectedLocation.island! + ", " + selectedLocation.city!
        }
        
        descLabel.text = selectedLocation.locDescription
        configureLabels()
        
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
        
        var height : CGFloat  = 0.0
        
        arcView.createArcWithWidth(arcWidth: 4.0, andWindArray: [selectedLocation.windSE,selectedLocation.windS,selectedLocation.windSW,selectedLocation.windW,selectedLocation.windNW,selectedLocation.windN,selectedLocation.windNE,selectedLocation.windE])
        arcView.isUserInteractionEnabled = false
        changesViewHeight.constant = 0.0
        changesView.isHidden = true
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
        request.predicate = NSPredicate(format: "forLocation == %@", selectedLocation!)
        request.returnsObjectsAsFaults = false
        
        do {
            imagesArray = try context.fetch(request) as! Array<Images>
            print(imagesArray)
            
        } catch {
            
            print("Failed")
        }
        
        var x : CGFloat = 0.0
        var y  : CGFloat = 0.0
        let width = (self.view.frame.width - 30) / 2
        for i in 0..<imagesArray.count {
            let img = UIImageView.init(frame: CGRect(x: x, y: y, width: width, height: width))
            img.image = UIImage(data: imagesArray[i].image! as Data)
            img.contentMode = .scaleAspectFit
            imagesView.addSubview(img)
            x = x + 10.0 + width
            if(i % 2 != 0) {
                y = y + 10.0 + width
                x = 0
            }
            else {
                height = height + 10.0 + width
            }
        }
        
        
        imagesViewHeight.constant = height
        
    }

    
    func configureLabels() {

        let coordinateFormat = UserDefaults.standard.value(forKey: "coordinateFormat") as! String
        switch coordinateFormat {
        case "Decimal Degree D.D°":
            coordinatesLabel.text = String(selectedLocation.latitude) + "°, " + String(selectedLocation.longitude) + "°"
            break
        case "Decimal Minutes D° M.M′":
            coordinatesLabel.text = calculationObj.convertFromDegreeDecimalToDegreeMinutes(selectedLocation.latitude, forType: "latitude") + ", " + calculationObj.convertFromDegreeDecimalToDegreeMinutes(selectedLocation.longitude, forType: "longitude")
            break
        case "Decimal Seconds D° M′ S.S":
            coordinatesLabel.text = calculationObj.convertFromDegreeDecimalToDegreeMinutesSeconds(selectedLocation.latitude, forType: "latitude") + ", " + calculationObj.convertFromDegreeDecimalToDegreeMinutesSeconds(selectedLocation.longitude, forType: "longitude")
            break
        default:
             coordinatesLabel.text = String(selectedLocation.latitude) + "°, " + String(selectedLocation.longitude) + "°"
            break
        }
        
        let depthFormat = UserDefaults.standard.value(forKey: "depthFormat") as! String
        switch depthFormat {
        case "metric system (metre)":
            depthLabel.text = String(selectedLocation.depth) + " metre"
            depthLabelTop.text = String(selectedLocation.depth) + " m"
            break
        case "imperial system (feet)":
            depthLabel.text = String(calculationObj.convertMetreToFeet(selectedLocation.depth)) + " feet"
            depthLabelTop.text = String(calculationObj.convertMetreToFeet(selectedLocation.depth)) + " feet"
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
      self.performSegue(withIdentifier: "editSegue", sender: self)
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
        
        
        if  (annotation is FBAnnotation) {
            
            if annotationView == nil {
                annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = annotation
            }
            
            if((annotation as! FBAnnotation).type == "Marina") {
                annotationView?.image = UIImage(named: "marina")
            }
            else if ((annotation as! FBAnnotation).type == "Buoy") {
                annotationView?.image = UIImage(named: "bouy")
            }
            else if ((annotation as! FBAnnotation).type == "Anchorage") {
                annotationView?.image = UIImage(named: "anchor")
            }
            else {
                annotationView?.image = UIImage(named: "mapMarker")
            }
            
        }
        return annotationView
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "editSegue" {
            let editNav = segue.destination as? UINavigationController
            let  editVC = editNav?.viewControllers.first as! AddEditViewController
            editVC.location = selectedLocation
            editVC.isFromSideMenu = false
            editVC.isNewLocation = false
        }
    }
 

}
