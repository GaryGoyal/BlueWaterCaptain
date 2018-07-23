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
    var selLatitude : Double!
    var selLongitude : Double!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.layer.borderColor = UIColor.lightGray.cgColor
        mapView.layer.borderWidth = 0.5
        
     }
    
    override func viewWillAppear(_ animated: Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        request.predicate = NSPredicate(format: "SELF == %@", selectedLocation!)
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request) as! Array<Location>
            if(results.count > 0) {
                selectedLocation = results.first
                selLatitude = selectedLocation.coordinates!.latitude
                selLongitude = selectedLocation.coordinates!.longitude
                configureView()
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func configureView() {

        let annotation = FBAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: selLatitude, longitude: selLongitude)
        annotation.title = selectedLocation.name?.name
        annotation.type = selectedLocation.type?.type
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: selLatitude, longitude: selLongitude), span: span)
        mapView.setRegion(region, animated: true)
        navBar.topItem?.title = selectedLocation.name?.name
        if((selectedLocation.name?.name?.count)! > 0) {
            nameLabel.text = selectedLocation.name?.name
        }
        else {
            nameLabel.text = " "
        }
        if((selectedLocation.island?.island?.count)! == 0 && (selectedLocation.city?.city?.count)! == 0) {
            islandLabel.text = " "
        }
        else if (selectedLocation.island?.island?.count == 0) {
            islandLabel.text = selectedLocation.city?.city!
        }
        else {
            islandLabel.text = (selectedLocation.island?.island!)! + ", " + (selectedLocation.city?.city!)!
        }
        
        descLabel.text = selectedLocation.locdescription?.locDescription
        configureLabels()
        
        if(selectedLocation.type?.type == "Marina") {
            mapMarker.image = UIImage(named: "marina")
        }
        else if (selectedLocation.type?.type == "Buoy") {
            mapMarker.image = UIImage(named: "bouy")
        }
        else if (selectedLocation.type?.type == "Anchorage") {
            mapMarker.image = UIImage(named: "anchor")
        }
        else {
            mapMarker.image = UIImage(named: "mapMarker")
        }
        
        var height : CGFloat  = 0.0
        
        arcView.createArcWithWidth(arcWidth: 4.0, andWindArray: [(selectedLocation.windSE?.windSE)!,(selectedLocation.windS?.windS)!,(selectedLocation.windSW?.windSW)!,(selectedLocation.windW?.windW)!,(selectedLocation.windNW?.windNW)!,(selectedLocation.windN?.windN)!,(selectedLocation.windNE?.windNE)!,(selectedLocation.windE?.windE)!])
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
            coordinatesLabel.text = String(selLatitude) + "°, " + String(selLongitude) + "°"
            break
        case "Decimal Minutes D° M.M′":
            coordinatesLabel.text = calculationObj.convertFromDegreeDecimalToDegreeMinutes(selLatitude, forType: "latitude") + ", " + calculationObj.convertFromDegreeDecimalToDegreeMinutes(selLongitude, forType: "longitude")
            break
        case "Decimal Seconds D° M′ S.S":
            coordinatesLabel.text = calculationObj.convertFromDegreeDecimalToDegreeMinutesSeconds((selLatitude)!, forType: "latitude") + ", " + calculationObj.convertFromDegreeDecimalToDegreeMinutesSeconds((selLongitude)!, forType: "longitude")
            break
        default:
            coordinatesLabel.text = String(selLatitude) + "°, " + String(selLongitude) + "°"
            break
        }
        
        let depthFormat = UserDefaults.standard.value(forKey: "depthFormat") as! String
        switch depthFormat {
        case "metric system (metre)":
            if let depth = selectedLocation.depth?.depth {
                depthLabel.text = String(depth) + " metre"
                depthLabelTop.text = String(depth) + " m"
            }
            break
        case "imperial system (feet)":
            depthLabel.text = String(calculationObj.convertMetreToFeet((selectedLocation.depth?.depth)!)) + " feet"
            depthLabelTop.text = String(calculationObj.convertMetreToFeet((selectedLocation.depth?.depth)!)) + " feet"
            break
        default:
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
