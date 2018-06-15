//
//  AddEditViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 6/4/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddEditViewController: UITableViewController, MKMapViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ArcViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var typeArray = ["Anchorage","Buoy","Marina"]
    var typePicker = UIPickerView()
    @IBOutlet weak var arcView : ArcView!
    
    @IBOutlet weak var duplicateViewHeight : NSLayoutConstraint!
    @IBOutlet weak var windViewHeight : NSLayoutConstraint!
    @IBOutlet weak var compassHeight : NSLayoutConstraint!
    
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var nameWidth : NSLayoutConstraint!
    @IBOutlet weak var prevNameView : UIView!
    @IBOutlet weak var prevNameLabel : UILabel!
    @IBOutlet weak var prevNameWidth : NSLayoutConstraint!
    @IBOutlet weak var nameField : UITextField!
    @IBOutlet weak var nameEditButton : UIButton!
    @IBOutlet weak var nameVerifyButton : UIButton!
    @IBOutlet weak var nameVerifyNo : UILabel!
    @IBOutlet weak var prevNameVerifyNo : UILabel!
     @IBOutlet weak var nameView : UIView!
    
    @IBOutlet weak var coourdinateLabel : UILabel!
    @IBOutlet weak var coordinateWidth : NSLayoutConstraint!
    @IBOutlet weak var prevCoordinateView : UIView!
    @IBOutlet weak var prevCoordinateLabel : UILabel!
    @IBOutlet weak var prevCoordinateWidth : NSLayoutConstraint!
    @IBOutlet weak var coordinateFieldView : UIView!
    @IBOutlet weak var latitudeField : UITextField!
    @IBOutlet weak var longitudeField : UITextField!
    @IBOutlet weak var coordinateEditButton : UIButton!
    @IBOutlet weak var coordinateVerifyButton : UIButton!
    @IBOutlet weak var coordinateVerifyNo : UILabel!
    @IBOutlet weak var prevCoordinateVerifyNo : UILabel!
     @IBOutlet weak var coordinateView : UIView!
    
    @IBOutlet weak var typeLabel : UILabel!
    @IBOutlet weak var prevTypeView : UIView!
    @IBOutlet weak var prevTypeLabel : UILabel!
    @IBOutlet weak var typeField : UITextField!
    @IBOutlet weak var typeEditButton : UIButton!
    @IBOutlet weak var typeVerifyButton : UIButton!
    @IBOutlet weak var typeVerifyNo : UILabel!
    @IBOutlet weak var prevTypeVerifyNo : UILabel!
    @IBOutlet weak var typeImage : UIImageView!
    @IBOutlet weak var typeWidth : NSLayoutConstraint!
    @IBOutlet weak var prevTypeWidth : NSLayoutConstraint!
     @IBOutlet weak var typeView : UIView!
    
    @IBOutlet weak var descLabel : UILabel!
    @IBOutlet weak var descWidth : NSLayoutConstraint!
    @IBOutlet weak var descField : UITextField!
    @IBOutlet weak var descEditButton : UIButton!
    @IBOutlet weak var descVerifyButton : UIButton!
    @IBOutlet weak var descVerifyNo : UILabel!
    @IBOutlet weak var prevDescVerifyNo : UILabel!
    @IBOutlet weak var prevDescView : UIView!
    @IBOutlet weak var prevDescLabel : UILabel!
    @IBOutlet weak var prevDescWidth : NSLayoutConstraint!
     @IBOutlet weak var descView : UIView!
    
    @IBOutlet weak var depthLabel : UILabel!
    @IBOutlet weak var depthWidth : NSLayoutConstraint!
    @IBOutlet weak var depthField : UITextField!
    @IBOutlet weak var depthEditButton : UIButton!
    @IBOutlet weak var depthVerifyButton : UIButton!
    @IBOutlet weak var depthVerifyNo : UILabel!
    @IBOutlet weak var prevDepthVerifyNo : UILabel!
    @IBOutlet weak var prevDepthView : UIView!
    @IBOutlet weak var prevDepthLabel : UILabel!
    @IBOutlet weak var prevDepthWidth : NSLayoutConstraint!
     @IBOutlet weak var depthView : UIView!
    
    @IBOutlet weak var islandLabel : UILabel!
    @IBOutlet weak var islandWidth : NSLayoutConstraint!
    @IBOutlet weak var islandField : UITextField!
    @IBOutlet weak var islandEditButton : UIButton!
    @IBOutlet weak var islandVerifyButton : UIButton!
    @IBOutlet weak var islandVerifyNo : UILabel!
    @IBOutlet weak var prevIslandVerifyNo : UILabel!
    @IBOutlet weak var prevIslandView : UIView!
    @IBOutlet weak var prevIslandLabel : UILabel!
    @IBOutlet weak var prevIslandWidth : NSLayoutConstraint!
     @IBOutlet weak var islandView : UIView!
    
    @IBOutlet weak var cityLabel : UILabel!
    @IBOutlet weak var cityWidth : NSLayoutConstraint!
    @IBOutlet weak var cityField : UITextField!
    @IBOutlet weak var cityEditButton : UIButton!
    @IBOutlet weak var cityVerifyButton : UIButton!
    @IBOutlet weak var cityVerifyNo : UILabel!
    @IBOutlet weak var prevCityVerifyNo : UILabel!
    @IBOutlet weak var prevCityView : UIView!
    @IBOutlet weak var prevCityLabel : UILabel!
    @IBOutlet weak var prevCityWidth : NSLayoutConstraint!
     @IBOutlet weak var cityView : UIView!
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var photoViewheight :  NSLayoutConstraint!
    
    var isSideMenuOpened = false
    var isFromSideMenu = false
    var revealViewController : SWRevealViewController!
    var isNewLocation = false
    var leftButton : UIBarButtonItem!
    var location : Location!
    var newAnnotation : CustomAnnotation!
    var changesArray = [Versioning]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let maxWidth = UIScreen.main.bounds.size.width - 120.0
    var imageArray = [NewLocationImage]()
    var windDirArray = [Int16]()
    
    //MARK: - View Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        typePicker.delegate = self
        typeField.inputView = typePicker
        
        if(isFromSideMenu) {
            leftButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(openSideMenu(_ :)))
        }
        else {
            leftButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SettingsViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
                
        if self.isNewLocation {
            self.navigationItem.title = "Add"
            duplicateViewHeight.constant = 0
            latitudeField.text = String(newAnnotation.coordinate.latitude)
            longitudeField.text = String(newAnnotation.coordinate.longitude)
            typeField.text = "Anchorage"
            typeImage.image = UIImage(named : "anchor")
            typePicker.selectRow(0, inComponent: 0, animated: false)
            windViewHeight.constant = 240
            compassHeight.constant = 200
            windDirArray = [-1,-1,-1,-1,-1,-1,-1,-1]
            arcView.layoutIfNeeded()
            
        }
        else {
            self.navigationItem.title = "Edit"
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Versioning")
            request.predicate = NSPredicate(format: "forLocation == %@", location!)
            request.returnsObjectsAsFaults = false
            do {
                changesArray = try context.fetch(request) as! Array<Versioning>
            } catch {
                
                print("Failed")
            }
             windDirArray = [location.windSE,location.windS,location.windSW,location.windW,location.windNW,location.windN,location.windNE,location.windE]
        }
            arcView.delegate = self
        arcView.isFilter = false
        arcView.createArcWithWidth(arcWidth: 15.0, andWindArray: windDirArray)
        leftButton.tintColor = UIColor.init(red: 18/255.0, green: 165/255.0, blue: 244/255.0, alpha: 1)
        self.navigationItem.leftBarButtonItem = leftButton
        addMapPin()

        configureName()
        configureCoordinates()
        configureDescription()
        configureDepth()
        configureLocationType()
        configureCity()
        configureIsland()
    }
    
    
    @objc func didTapView(){
        self.view.endEditing(true)
       /* if(depthLabel.isEnabled) {
            depthLabel.isEnabled = false
        }
        if(degreeLabel.isEnabled) {
            print(UserDefaults.standard.value(forKey: "coordinateFormat")!)
            degreeLabel.isEnabled = false
        }*/
        /* if(dateLabel.isEnabled) {
         dateLabel.isEnabled = false
         }
         if(timeLabel.isEnabled) {
         timeLabel.isEnabled = false
         }*/
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addMapPin() {
        
        
        let annotation : CustomAnnotation!
        if isNewLocation {
            annotation = newAnnotation
        }
        else {
            annotation = CustomAnnotation(coordinate:  CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            annotation.title = location.name
            annotation.type = location.type
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), span: span)
        //  let region  = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
        mapView.setRegion(region, animated: true)
    }
    
    
    @objc func openSideMenu(_ sender : UIBarButtonItem) {
        
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
    
    func updateWindDirections(_ windArray: Array<Int16>) {
        windDirArray = windArray
    }
    
    //MARK: - Configure views
    
    func configureName() {
        if isNewLocation {
            nameView.isHidden = true
            prevNameView.isHidden = true
            prevNameLabel.text = ""
            nameField.isHidden = false
            nameEditButton.isHidden = true
        }
        else {
            nameView.isHidden = false
            nameField.isHidden = true
            nameVerifyNo.text = String(location.verifications!.name)
            if(location.name?.count == 0) {
                nameLabel.text = " "
            }
            else {
                nameLabel.text = location.name
            }
            if(nameLabel.intrinsicContentSize.width > maxWidth) {
                nameWidth.constant = maxWidth
            }
            else {
                nameWidth.constant = nameLabel.intrinsicContentSize.width
            }
           var filteredArray = changesArray.filter() {  $0.attributeId == "name" }
            if(filteredArray.count > 0) {
              //  print(filteredArray)
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevNameView.isHidden = false
                prevNameLabel.text = filteredArray.first?.previousValue
                prevNameVerifyNo.text = String(filteredArray.first!.verification)
                if(prevNameLabel.intrinsicContentSize.width > maxWidth) {
                    prevNameWidth.constant = maxWidth
                }
                else {
                    prevNameWidth.constant = prevNameLabel.intrinsicContentSize.width
                }
            }
            else {
                prevNameView.isHidden = true
                prevNameLabel.text = ""
            }
        }
    }
    
    func configureCoordinates() {
        if isNewLocation {
            coordinateView.isHidden = true
            prevCoordinateView.isHidden = true
             prevCoordinateLabel.text = ""
            coordinateFieldView.isHidden = false
            coordinateEditButton.isHidden = true
        }
        else {
            coordinateView.isHidden = false
            coordinateFieldView.isHidden = true
            coordinateVerifyNo.text = String(location.verifications!.coordinates)
            coourdinateLabel.text = "\(location.latitude)" + ", " + "\(location.longitude)"
            if(coourdinateLabel.intrinsicContentSize.width > maxWidth) {
                coordinateWidth.constant = maxWidth
            }
            else {
                coordinateWidth.constant = coourdinateLabel.intrinsicContentSize.width
            }
            var filteredLatArray = changesArray.filter() {  $0.attributeId == "latitude" }
            var filteredLongArray = changesArray.filter() {  $0.attributeId == "longitude" }
            print(filteredLatArray)
            print(filteredLongArray)
            if(filteredLatArray.count > 0) {
                prevCoordinateView.isHidden = false
                filteredLatArray = filteredLatArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
            }
            if(filteredLongArray.count > 0) {
                prevCoordinateView.isHidden = false
                filteredLongArray = filteredLongArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
            }
            
             if(filteredLatArray.count > 0) {
                
                prevCoordinateLabel.text = "\(filteredLatArray.first!.previousValue!)" + ", " + "\(filteredLongArray.first!.previousValue!)"
                prevCoordinateVerifyNo.text = String(filteredLatArray.first!.verification)
                if(prevCoordinateLabel.intrinsicContentSize.width > maxWidth) {
                    prevCoordinateWidth.constant = maxWidth
                }
                else {
                    prevCoordinateWidth.constant = prevCoordinateLabel.intrinsicContentSize.width
                }
                
            }
            else {
                prevCoordinateView.isHidden = true
                prevCoordinateLabel.text = ""
            }
        }
    }
    
    func configureLocationType() {

        if isNewLocation {
            typeView.isHidden = true
            prevTypeView.isHidden = true
             prevTypeLabel.text = ""
            typeField.isHidden = false
            typeEditButton.isHidden = true
        }
        else {
            typeView.isHidden = false
            typeField.isHidden = true
            typeVerifyNo.text = String(location.verifications!.type)
            typeLabel.text = location.type
            if(typeLabel.intrinsicContentSize.width > (maxWidth - 60)) {
                typeWidth.constant = (maxWidth - 60)
            }
            else {
               typeWidth.constant = typeLabel.intrinsicContentSize.width
            }
            var filteredArray = changesArray.filter() {  $0.attributeId == "type" }
            if(filteredArray.count > 0) {
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevTypeView.isHidden = false
                prevTypeLabel.text = filteredArray.first?.previousValue
                prevTypeVerifyNo.text = String(filteredArray.first!.verification)
                if(prevTypeLabel.intrinsicContentSize.width > (maxWidth - 60)) {
                    prevTypeWidth.constant = (maxWidth - 60)
                }
                else {
                    prevTypeWidth.constant = prevTypeLabel.intrinsicContentSize.width
                }
            }
            else {
                prevTypeView.isHidden = true
                prevTypeLabel.text = ""
            }
            if(location.type == "Marina") {
                typeImage.image = UIImage(named: "marina")
            }
            else if (location.type == "Buoy") {
                typeImage.image = UIImage(named: "bouy")
            }
            else if (location.type == "Anchorage") {
                typeImage.image = UIImage(named: "anchor")
            }
        }
    }
    
    func configureDepth() {
        if isNewLocation {
            depthView.isHidden = true
            prevDepthView.isHidden = true
            prevDepthLabel.text = ""
            depthField.isHidden = false
            depthEditButton.isHidden = true
        }
        else {
            depthView.isHidden = false
            depthField.isHidden = true
            depthVerifyNo.text = String(location.verifications!.depth)
            depthLabel.text = String(location.depth) + " metre"
            if(depthLabel.intrinsicContentSize.width > (maxWidth - 55)) {
                depthWidth.constant = (maxWidth - 55)
            }
            else {
                depthWidth.constant = depthLabel.intrinsicContentSize.width
            }
            var filteredArray = changesArray.filter() {  $0.attributeId == "depth" }
            if(filteredArray.count > 0) {
               // print(filteredArray)
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevDepthView.isHidden = false
                prevDepthLabel.text = String(filteredArray.first!.previousValue!) + " metre"
                prevDepthVerifyNo.text = String(filteredArray.first!.verification)
                if(prevDepthLabel.intrinsicContentSize.width > (maxWidth - 50)) {
                    prevDepthWidth.constant = (maxWidth - 50)
                }
                else {
                    prevDepthWidth.constant = prevDepthLabel.intrinsicContentSize.width
                }
            }
            else {
                prevDepthView.isHidden = true
                prevDepthLabel.text = ""
            }
        }
    }
    
    func configureDescription() {
        if isNewLocation {
            descView.isHidden = true
            prevDescView.isHidden = true
            descField.isHidden = false
             prevDescLabel.text = ""
            descEditButton.isHidden = true
        }
        else {
            descView.isHidden = false
            descField.isHidden = true
            descVerifyNo.text = String(location.verifications!.locDescription)
            if(location.locDescription?.count == 0) {
                descLabel.text = " "
            }
            else {
                descLabel.text = location.locDescription
            }
            cityLabel.text = location.city
            if(descLabel.intrinsicContentSize.width > maxWidth) {
                descWidth.constant = maxWidth
            }
            else {
                descWidth.constant = descLabel.intrinsicContentSize.width
            }
            var filteredArray = changesArray.filter() {  $0.attributeId == "description" }
            if(filteredArray.count > 0) {
               // print(filteredArray)
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevDescView.isHidden = false
                prevDescLabel.text = filteredArray.first?.previousValue
                prevDescVerifyNo.text = String(filteredArray.first!.verification)
                if(prevDescLabel.intrinsicContentSize.width > maxWidth) {
                    prevDescWidth.constant = maxWidth
                }
                else {
                    prevDescWidth.constant = prevDescLabel.intrinsicContentSize.width
                }
            }
            else {
                prevDescView.isHidden = true
                prevDescLabel.text = ""
            }
        }
    }
    
    func configureCity() {
        if isNewLocation {
            cityView.isHidden = true
            prevCityView.isHidden = true
             prevCityLabel.text = ""
            cityField.isHidden = false
            cityEditButton.isHidden = true
        }
        else {
            cityView.isHidden = false
            cityField.isHidden = true
            cityVerifyNo.text = String(location.verifications!.city)
            if(location.city?.count == 0) {
                cityLabel.text = " "
            }
            else {
                cityLabel.text = location.city
            }
            if(cityLabel.intrinsicContentSize.width > maxWidth) {
                cityWidth.constant = maxWidth
            }
            else {
                cityWidth.constant = cityLabel.intrinsicContentSize.width
            }
            var filteredArray = changesArray.filter() {  $0.attributeId == "city" }
            if(filteredArray.count > 0) {
                //  print(filteredArray)
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevCityView.isHidden = false
                prevCityLabel.text = filteredArray.first?.previousValue
                prevCityVerifyNo.text = String(filteredArray.first!.verification)
                if(prevCityLabel.intrinsicContentSize.width > maxWidth) {
                    prevCityWidth.constant = maxWidth
                }
                else {
                    prevCityWidth.constant = prevCityLabel.intrinsicContentSize.width
                }
            }
            else {
                prevCityView.isHidden = true
                prevCityLabel.text = ""
            }
        }
    }
    
    
    func configureIsland() {
        if isNewLocation {
            islandView.isHidden = true
            prevIslandView.isHidden = true
             prevIslandLabel.text = ""
            islandField.isHidden = false
            islandEditButton.isHidden = true
        }
        else {
            islandView.isHidden = false
            islandField.isHidden = true
            islandVerifyNo.text = String(location.verifications!.island)
            if(location.island?.count == 0) {
                islandLabel.text = " "
            }
            else {
                islandLabel.text = location.island
            }
            if(islandLabel.intrinsicContentSize.width > maxWidth) {
                islandWidth.constant = maxWidth
            }
            else {
                islandWidth.constant = islandLabel.intrinsicContentSize.width
            }
            var filteredArray = changesArray.filter() {  $0.attributeId == "island" }
            if(filteredArray.count > 0) {
                //  print(filteredArray)
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevIslandView.isHidden = false
                prevIslandLabel.text = filteredArray.first?.previousValue
                prevIslandVerifyNo.text = String(filteredArray.first!.verification)
                if(prevIslandLabel.intrinsicContentSize.width > maxWidth) {
                    prevIslandWidth.constant = maxWidth
                }
                else {
                    prevIslandWidth.constant = prevIslandLabel.intrinsicContentSize.width
                }
            }
            else {
                prevIslandView.isHidden = true
                prevIslandLabel.text = ""
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.section == 5) {
         return 280
        }
        else {
            return UITableViewAutomaticDimension
        }
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 5) {
            return 280
        }
        else {
            return 50
        }
    }
    
    
    //MARK: Button actions
    
       @objc func cancelButtonTapped() {
        
      /* let entity = NSEntityDescription.entity(forEntityName: "Versioning", in: context)
        let newChange = NSManagedObject(entity: entity!, insertInto: context) as! Versioning
       newChange.attributeId = "type"
        newChange.previousValue = location.type
        newChange.timeOfChange = Date() as NSDate
        newChange.verification = 0
        newChange.forLocation = location
        location.type = "Anchorage"
        
        let newChange1 = NSManagedObject(entity: entity!, insertInto: context) as! Versioning
        newChange.attributeId = "depth"
        newChange1.previousValue = String(location.depth)
        newChange1.timeOfChange = Date() as NSDate
        newChange1.verification = 0
        newChange1.forLocation = location
        location.depth = 56
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }*/
        
     /*    let entity = NSEntityDescription.entity(forEntityName: "Versioning", in: context)
         let newChange = NSManagedObject(entity: entity!, insertInto: context) as! Versioning
         newChange.attributeId = "longitude"
         newChange.previousValue = String(location.longitude)
         newChange.timeOfChange = Date() as NSDate
         newChange.verification = 0
         newChange.forLocation = location
         location.longitude = 12.573
        
          let entity1 = NSEntityDescription.entity(forEntityName: "Versioning", in: context)
         let newChange1 = NSManagedObject(entity: entity1!, insertInto: context) as! Versioning
         newChange1.attributeId = "latitude"
         newChange1.previousValue = String(location.latitude)
         newChange1.timeOfChange = Date() as NSDate
         newChange1.verification = 0
         newChange1.forLocation = location
         do {
         try context.save()
         } catch {
         print("Failed saving")
         }
        self.dismiss(animated: true, completion: nil)*/
        
      /*  let entity = NSEntityDescription.entity(forEntityName: "Versioning", in: context)
        let newChange = NSManagedObject(entity: entity!, insertInto: context) as! Versioning
        newChange.attributeId = "city"
        newChange.previousValue = location.city
        newChange.timeOfChange = Date() as NSDate
        newChange.verification = 0
        newChange.forLocation = location
        location.city = "Singapore"
        
        let entity1 = NSEntityDescription.entity(forEntityName: "Versioning", in: context)
        let newChange1 = NSManagedObject(entity: entity1!, insertInto: context) as! Versioning
        newChange1.attributeId = "island"
        newChange1.previousValue = location.island
        newChange1.timeOfChange = Date() as NSDate
        newChange1.verification = 0
        newChange1.forLocation = location
        location.island = "THIS IS sunderbans island. It is very beutoful"
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }*/
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonTapped(_ sender : Any) {
        
        if(latitudeField.text?.count == 0 || longitudeField.text?.count == 0) {
            let alertMessage: UIAlertController = self.showAlert(withTitle: "ERROR", andMessage: "Please enter coordinates of the location properly")
            self.present(alertMessage, animated: true, completion: nil)
            return
        }
        
        
        if(isNewLocation) {
            
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
            let newLoc = NSManagedObject(entity: entity!, insertInto: context) as! Location

            newLoc.windSE = windDirArray[0]
            newLoc.windS = windDirArray[1]
            newLoc.windSW = windDirArray[2]
            newLoc.windW = windDirArray[3]
            newLoc.windNW = windDirArray[4]
            newLoc.windN = windDirArray[5]
            newLoc.windNE = windDirArray[6]
            newLoc.windE = windDirArray[7]
            
            newLoc.name = nameField.text
            newLoc.island = islandField.text
            newLoc.city = cityField.text
            newLoc.latitude = Double(latitudeField.text!)!
            newLoc.longitude = Double(longitudeField.text!)!
            if((depthField.text?.count)! > 0) {
                newLoc.depth = Double(depthField.text!)!
            }
            else {
                newLoc.depth = 0.0
            }
            newLoc.locDescription = descField.text
            newLoc.type = typeField.text
            for i in 0..<imageArray.count {
                let entity = NSEntityDescription.entity(forEntityName: "Images", in: context)
                let newImg = NSManagedObject(entity: entity!, insertInto: context) as! Images
                newImg.verification = 0
                newImg.image = UIImageJPEGRepresentation((imageArray[i] as NewLocationImage).locImage, 0.5)! as NSData
                newImg.forLocation = newLoc
            }
            
            let entity1 = NSEntityDescription.entity(forEntityName: "Verification", in: context)
            let newVer = NSManagedObject(entity: entity1!, insertInto: context) as! Verification
            newVer.city = 0
            newVer.depth = 0
            newVer.name = 0
            newVer.island = 0
            newVer.locDescription = 0
            newVer.coordinates = 0
            newVer.type = 0
            newVer.windSE = 0
            newVer.windSW = 0
            newVer.windNE = 0
            newVer.windNW = 0
            newVer.windN = 0
            newVer.windE = 0
            newVer.windW = 0
            newVer.windS = 0
            newVer.depth = 0
            newVer.forLocation = newLoc
            
            do {
                try context.save()
                let alert = UIAlertController(title: "SUCCESS", message: "The location is saved successfully", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler:
                { (action:UIAlertAction) in
                    self.newLocationAddedResult()
                })
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            } catch {
                let alertMessage: UIAlertController = self.showAlert(withTitle: "ERROR", andMessage: "There was an error saving this location. Please try again")
                self.present(alertMessage, animated: true, completion: nil)
                
            }
            
        }
            else {
            
        }
        
        
    }
    
    
    func newLocationAddedResult()
    {
        if(!isFromSideMenu) {
             self.dismiss(animated: true, completion: nil)
        }
    }

    
    // MARK: - Alert Message
    
    func showAlert(withTitle title : String, andMessage message:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        return alert
    }
    
     @IBAction func editCoordinateButtonTapped(_ sender : Any) {
        coordinateView.isHidden = true
        prevCoordinateView.isHidden = true
        prevCoordinateLabel.text = ""
        coordinateFieldView.isHidden = false
        latitudeField.becomeFirstResponder()
    }
    
    @IBAction func editBuoyButtonTapped(_ sender : Any) {
        typeView.isHidden = true
        prevTypeView.isHidden = true
        prevTypeLabel.text = ""
        typeField.isHidden = false
        typeField.becomeFirstResponder()
    }
    
    @IBAction func editNameButtonTapped(_ sender : Any) {
        nameView.isHidden = true
        nameField.isHidden = false
        nameField.text = nameLabel.text
        nameField.becomeFirstResponder()
    }
    
    @IBAction func editIslandButtonTapped(_ sender : Any) {
        islandView.isHidden = true
        prevIslandView.isHidden = true
        islandField.isHidden = false
        islandField.text = islandLabel.text
        islandField.becomeFirstResponder()
    }
    
  
     func updatePrevFields() {

    }
    
    @IBAction func cameraButtonTapped(_ sender : Any) {

        self.tableView.reloadData()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            self.present(imagePicker, animated: true, completion: nil)
        }
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
    
    // MARK: - Textfield delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(!isNewLocation) {
            if(textField == latitudeField || textField == longitudeField) {
                coordinateView.isHidden = false
                coordinateFieldView.isHidden = true
            }
            
            if(textField == islandField) {
                islandView.isHidden = false
                islandField.isHidden = true
                islandLabel.text = islandField.text
            }
            
            if(textField == nameField) {
                nameField.isHidden = true
                nameView.isHidden = false
                nameLabel.text = nameField.text
            }
        }
        
       
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Pickerview Datasource and Delegates
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeArray.count
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return typeArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       typeField.text = typeArray[row]
        if(typeArray[row] == "Marina") {
            typeImage.image = UIImage(named: "marina")
        }
        else if (typeArray[row] == "Buoy") {
            typeImage.image = UIImage(named: "bouy")
        }
        else if (typeArray[row] == "Anchorage") {
            typeImage.image = UIImage(named: "anchor")
        }
        else {
            typeImage.image = UIImage(named: "mapMarker")
        }
    }
    
    // MARK: - Image Picker Controller Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      /*  let img : NewLocationImage = NewLocationImage.instanceFromNibWithFrame(frame: CGRect(x: 0, y:50 + CGFloat(imageArray.count * 180), width:self.view.frame.size.width, height: 180)) as! NewLocationImage
        img.photo.image = image
        img.layer.borderColor = UIColor.red.cgColor
        img.layer.borderWidth = 2.0
        img.backgroundColor = UIColor.yellow
        img.clipsToBounds = true
        print(img)
        imageArray.append(img)
        img.deleteButton.addTarget(self, action: #selector(deleteImage(_ :)), for: .touchUpInside)
        photoView.addSubview(img)
        photoViewheight.constant = photoViewheight.constant + 500
        self.tableView.reloadData()
        picker.dismiss(animated:true, completion: nil)*/
        
        let img : NewLocationImage = NewLocationImage(frame: CGRect(x: 0, y:50 + CGFloat(imageArray.count * 180), width:self.view.frame.size.width, height: 180))
        img.backgroundColor = UIColor.white
        
        let separator = UIView(frame:  CGRect(x: 15, y:0, width:self.view.frame.size.width - 15, height: 0.5))
        separator.backgroundColor = UIColor.lightGray
        img.addSubview(separator)
        
        let imgView = UIImageView(frame:  CGRect(x: 10, y:15, width:200, height: 150))
        imgView.contentMode = .scaleAspectFit
        imgView.image = image
        img.addSubview(imgView)
        
        let deleteButton = UIButton(type: .custom)
        deleteButton.frame = CGRect(x: self.view.frame.size.width - 40, y:15, width:30, height: 30)
        deleteButton.setBackgroundImage(UIImage(named : "cross"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteImage(_ :)), for: .touchUpInside)
        img.addSubview(deleteButton)
        
        img.locImage = image
        photoView.addSubview(img)
        photoViewheight.constant = photoViewheight.constant + 180
        self.tableView.reloadData()
        imageArray.append(img)
        picker.dismiss(animated:true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true, completion: nil)
    }
    
    @objc func deleteImage(_ sender : Any) {
      //  print(imageArray)
        let imgTodelete : NewLocationImage = (sender as! UIButton).superview as! NewLocationImage
        imgTodelete.removeFromSuperview()
        let index = imageArray.index(of: imgTodelete)
        imageArray.remove(at: index!)
        
        var y : CGFloat = 50.0
        for var i in index!..<imageArray.count {
//            let imgView = imageArray[i] as NewLocationImage
//            imgView.frame = CGRect(x: 0, y:y, width:self.view.frame.size.width, height: 180)
//            y = y + 180
//
             let imgView = imageArray[i] as NewLocationImage
            imgView.frame.origin.y = imgView.frame.origin.y - 180
               print(imgView)
        }
//
        photoViewheight.constant = photoViewheight.constant - 180
        print(photoViewheight.constant)
        self.tableView.reloadData()
    }
    
   // setFrameForView(

    // MARK: - Table view data source

  /*  override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
