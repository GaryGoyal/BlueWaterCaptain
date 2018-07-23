//
//  HelpCaptainsViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 7/14/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
import FBAnnotationClusteringSwift

class HelpCaptainsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    var isSideMenuOpened = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var noPhotoArray = [Location]()
    var noSafetyArray = [Location]()
    var noVerificationArray = [Location]()
    var noDetailsArray = [Location]()
     var allObjArray = [Dictionary<String, Location>]()
    var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
    @IBOutlet weak var helpTable: UITableView!
    @IBOutlet weak var optionsSegment: UISegmentedControl!
     var selectedLocation : Location!
     let locationManager = CLLocationManager()
    var currentLatitude : Double = UserDefaults.standard.double(forKey: "defaultLatitude")
    var currentLongitude : Double = UserDefaults.standard.double(forKey: "defaultLongitude")
     var isDistanceCalculated = false
//
    override func viewDidLoad() {
        super.viewDidLoad()

        optionsSegment.selectedSegmentIndex = 0
        request.returnsObjectsAsFaults = false
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNoPhotoLocations()
        getNoSafetyLocations()
        getNoDetailsLocations()
        getNoVerificationLocations()
        sortData()
    }
    
    func getNoDetailsLocations() {
        let predicate1 = NSPredicate(format: "SELF.name.name == %@","")
        let predicate2 = NSPredicate(format: "SELF.city.city == %@","")
        let predicate3 = NSPredicate(format: "SELF.locdescription.locDescription == %@","")
        let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1,predicate2,predicate3])
        request.predicate = predicateCompound
        do {
            noDetailsArray = try context.fetch(request) as! Array<Location>
            print(noDetailsArray.count)
            
        } catch {  }
    }
    
    func getNoSafetyLocations() {
        let predicate1 = NSPredicate(format: "SELF.windSE.windSE == %d",-1)
         let predicate2 = NSPredicate(format: "SELF.windS.windS == %d",-1)
         let predicate3 = NSPredicate(format: "SELF.windSW.windSW == %d",-1)
         let predicate4 = NSPredicate(format: "SELF.windW.windW == %d",-1)
         let predicate5 = NSPredicate(format: "SELF.windNW.windNW == %d",-1)
         let predicate6 = NSPredicate(format: "SELF.windN.windN == %d",-1)
         let predicate7 = NSPredicate(format: "SELF.windNE.windNE == %d",-1)
         let predicate8 = NSPredicate(format: "SELF.windE.windE == %d",-1)

        let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1,predicate2,predicate3,predicate4,predicate5,predicate6,predicate7,predicate8])
        request.predicate = predicateCompound
        do {
            noSafetyArray = try context.fetch(request) as! Array<Location>
            print(noSafetyArray.count)
            
        } catch {  }
    }
    
    func getNoVerificationLocations() {
        
        let predicate1 = NSPredicate(format: "SELF.windSE.verifiedBy.@count == %d",0)
        let predicate2 = NSPredicate(format: "SELF.windS.verifiedBy.@count == %d",0)
        let predicate3 = NSPredicate(format: "SELF.windSW.verifiedBy.@count == %d",0)
        let predicate4 = NSPredicate(format: "SELF.windW.verifiedBy.@count == %d",0)
        let predicate5 = NSPredicate(format: "SELF.windNW.verifiedBy.@count == %d",0)
        let predicate6 = NSPredicate(format: "SELF.windN.verifiedBy.@count == %d",0)
        let predicate7 = NSPredicate(format: "SELF.windNE.verifiedBy.@count == %d",0)
        let predicate8 = NSPredicate(format: "SELF.windE.verifiedBy.@count == %d",0)
        let predicate9 = NSPredicate(format: "SELF.name.verifiedBy.@count == %d",0)
        let predicate10 = NSPredicate(format: "SELF.type.verifiedBy.@count == %d",0)
        let predicate11 = NSPredicate(format: "SELF.city.verifiedBy.@count == %d",0)
        let predicate12 = NSPredicate(format: "SELF.island.verifiedBy.@count == %d",0)
        let predicate13 = NSPredicate(format: "SELF.coordinates.verifiedBy.@count == %d",0)
        let predicate14 = NSPredicate(format: "SELF.depth.verifiedBy.@count == %d",0)
        let predicate15 = NSPredicate(format: "SELF.locdescription.verifiedBy.@count == %d",0)
        
        let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1,predicate2,predicate3,predicate4,predicate5,predicate6,predicate7,predicate8,predicate9,predicate10,predicate11,predicate12,predicate13,predicate14,predicate15])
        request.predicate = predicateCompound
        do {
            noVerificationArray = try context.fetch(request) as! Array<Location>
            print(noVerificationArray.count)
            
        } catch {  }
    }
    
    func getNoPhotoLocations() {
        request.predicate = NSPredicate(format: "SELF.images.@count == %d", 0)
        do {
            noPhotoArray = try context.fetch(request) as! Array<Location>
            print(noPhotoArray.count)
            
        } catch {  }
    }
    
    func createAllLocationArray() {
        
        for i in 0..<noPhotoArray.count {
            allObjArray.append(["noPhoto" : noPhotoArray[i]])
        }
        for i in 0..<noDetailsArray.count {
            allObjArray.append(["noDetail" : noDetailsArray[i]])
        }
        for i in 0..<noSafetyArray.count {
            allObjArray.append(["noSafety" : noSafetyArray[i]])
        }
        for i in 0..<noVerificationArray.count {
            allObjArray.append(["noVerification" : noVerificationArray[i]])
        }
    }
    
    func sortData() {
        
        let currentCoordinates = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        for i in 0..<noPhotoArray.count {
            
            let coordinate1 = CLLocation(latitude: (noPhotoArray[i].coordinates?.latitude)!, longitude: (noPhotoArray[i].coordinates?.longitude)!)
        
            noPhotoArray[i].distance = currentCoordinates.distance(from: coordinate1)
        }
        
        for i in 0..<noSafetyArray.count {
            
            let coordinate1 = CLLocation(latitude: (noSafetyArray[i].coordinates?.latitude)!, longitude: (noSafetyArray[i].coordinates?.longitude)!)

            noSafetyArray[i].distance = currentCoordinates.distance(from: coordinate1)
        }
        
        for i in 0..<noDetailsArray.count {
            
            let coordinate1 = CLLocation(latitude: (noDetailsArray[i].coordinates?.latitude)!, longitude: (noDetailsArray[i].coordinates?.longitude)!)

            noDetailsArray[i].distance = currentCoordinates.distance(from: coordinate1)
        }
        
        for i in 0..<noVerificationArray.count {
            
            let coordinate1 = CLLocation(latitude: (noVerificationArray[i].coordinates?.latitude)!, longitude: (noVerificationArray[i].coordinates?.longitude)!)

            noVerificationArray[i].distance = currentCoordinates.distance(from: coordinate1)
        }
        
        noPhotoArray = noPhotoArray.sorted(by: { $0.distance < $1.distance })
         noVerificationArray = noVerificationArray.sorted(by: { $0.distance < $1.distance })
         noDetailsArray = noDetailsArray.sorted(by: { $0.distance < $1.distance })
         noSafetyArray = noSafetyArray.sorted(by: { $0.distance < $1.distance })
        

        allObjArray.removeAll()
        createAllLocationArray()
        allObjArray = allObjArray.sorted(by: { ($0.values.first?.distance)! < ($1.values.first?.distance)! })
       
        helpTable.reloadData()
        
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
    
    // MARK: - Tableview dataSource and delegate methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        switch optionsSegment.selectedSegmentIndex {
        case 0:
            return allObjArray.count
        case 1:
            return noPhotoArray.count
        case 2:
            return noDetailsArray.count
        case 3:
            return noSafetyArray.count
        case 4:
            return noVerificationArray.count
        default:
            return allObjArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : HelpCell!
        var location : Location!
        
        switch optionsSegment.selectedSegmentIndex {
        case 0:

            print(indexPath.row)
            if(allObjArray[indexPath.row].keys.first == "noPhoto") {
                cell = tableView.dequeueReusableCell(withIdentifier: "noPhotoCell", for: indexPath) as! HelpCell
                location = allObjArray[indexPath.row]["noPhoto"]
            }
            else if(allObjArray[indexPath.row].keys.first == "noDetail") {
                cell = tableView.dequeueReusableCell(withIdentifier: "noDetailCell", for: indexPath) as! HelpCell
                location = allObjArray[indexPath.row]["noDetail"]
                cell.editLabel?.text = "Add "
                if(location.name?.name?.count == 0) {
                    cell.editLabel?.text = (cell.editLabel?.text)! + "Name, "
                }
                if(location.city?.city?.count == 0) {
                    cell.editLabel?.text = (cell.editLabel?.text)! + "City, "
                }
                if(location.locdescription?.locDescription?.count == 0) {
                    cell.editLabel?.text = (cell.editLabel?.text)! + "Description "
                }
            }
            else if(allObjArray[indexPath.row].keys.first == "noSafety") {
                cell = tableView.dequeueReusableCell(withIdentifier: "noSafetyCell", for: indexPath) as! HelpCell
                location = allObjArray[indexPath.row]["noSafety"]
                let windDirArray = [location.windSE?.windSE,location.windS?.windS,location.windSW?.windSW,location.windW?.windW,location.windNW?.windNW,location.windN?.windN,location.windNE?.windNE,location.windE?.windE] as! [Int16]
                cell.arcView?.isUserInteractionEnabled = false
                cell.arcView?.createArcWithWidth(arcWidth: 5.0, andWindArray: windDirArray)

            }
            else if(allObjArray[indexPath.row].keys.first == "noVerification"){
                cell = tableView.dequeueReusableCell(withIdentifier: "noVerificationCell", for: indexPath) as! HelpCell
                location = allObjArray[indexPath.row]["noVerification"]
            }
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "noPhotoCell", for: indexPath) as! HelpCell
            location = noPhotoArray[indexPath.row]

        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "noDetailCell", for: indexPath) as! HelpCell
            location = noDetailsArray[indexPath.row]
            cell.editLabel?.text = "Add "
            if(location.name?.name?.count == 0) {
                cell.editLabel?.text = (cell.editLabel?.text)! + "Name, "
            }
            if(location.city?.city?.count == 0) {
                cell.editLabel?.text = (cell.editLabel?.text)! + "City, "
            }
            if(location.locdescription?.locDescription?.count == 0) {
                cell.editLabel?.text = (cell.editLabel?.text)! + "Description "
            }
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "noSafetyCell", for: indexPath) as! HelpCell
            location = noSafetyArray[indexPath.row]

            let windDirArray = [location.windSE?.windSE,location.windS?.windS,location.windSW?.windSW,location.windW?.windW,location.windNW?.windNW,location.windN?.windN,location.windNE?.windNE,location.windE?.windE] as! [Int16]
            cell.arcView?.isUserInteractionEnabled = false
            cell.arcView?.createArcWithWidth(arcWidth: 5.0, andWindArray: windDirArray)
            
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "noVerificationCell", for: indexPath) as! HelpCell
            location = noVerificationArray[indexPath.row]
           
        default:
            break
        }
        
        cell.editButton.tag = indexPath.row + 1
        cell.editButton.addTarget(self, action: #selector(editLocation(_ :)), for: .touchUpInside)
        let type = location.type?.type
        if(location.name?.name?.count == 0) {
            cell.headingLabel.text = type
        }
        else {
            cell.headingLabel.text = location.name?.name
        }

        let annotation = FBAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (location.coordinates?.latitude)!, longitude: (location.coordinates?.longitude)!)
        annotation.title = location.name?.name
        annotation.type = location.type?.type
        cell.mapView.delegate = self
        cell.mapView.removeAnnotations(cell.mapView.annotations)
        cell.mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (location.coordinates?.latitude)!, longitude: (location.coordinates?.longitude)!), span: span)
        cell.mapView.setRegion(region, animated: true)
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch optionsSegment.selectedSegmentIndex {
        case 0:
            if(allObjArray[indexPath.row].keys.first == "noSafety") {
               return 160
            }
            else {
               return 100
            }
           
        case 1:
            return 100
        case 2:
            return 100
        case 3:
            return 160
        case 4:
            return 100
        default:
            return 100
        }
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
    
    
    @IBAction func segmentValueChanged(_ sender : Any) {

//        let indexPath = NSIndexPath(row: 0, section: 0)
//        helpTable.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        helpTable.setContentOffset(CGPoint.zero, animated: false)
        helpTable.reloadData()
        helpTable.layoutIfNeeded()
        helpTable.setContentOffset(CGPoint.zero, animated: false)

    }

     func editLocation(_ sender : UIButton) {
        switch optionsSegment.selectedSegmentIndex {
        case 0:
            selectedLocation = allObjArray[sender.tag - 1].values.first
        case 1:
            selectedLocation = noPhotoArray[sender.tag - 1]
        case 2:
            selectedLocation = noDetailsArray[sender.tag - 1]
        case 3:
            selectedLocation = noSafetyArray[sender.tag - 1]
        case 4:
            selectedLocation = noVerificationArray[sender.tag - 1]
        default:
            break
        }
        self.performSegue(withIdentifier: "helpEditSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "helpEditSegue" {
            let editNav = segue.destination as? UINavigationController
            let  editVC = editNav?.viewControllers.first as! AddEditViewController
            editVC.location = selectedLocation
            editVC.isFromSideMenu = false
            editVC.isNewLocation = false
        }
    }
    
// MARK: - CoreLocation Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let location = locations.first else { return }

        let currentLocation = locations.last

        if(!isDistanceCalculated) {
            currentLatitude = (currentLocation?.coordinate.latitude)!
            currentLongitude = (currentLocation?.coordinate.longitude)!
            isDistanceCalculated = true
            sortData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }

}
