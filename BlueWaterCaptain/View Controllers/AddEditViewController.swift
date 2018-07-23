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
import FBAnnotationClusteringSwift

class AddEditViewController: UITableViewController, MKMapViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ArcViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var typeArray = ["Anchorage","Buoy","Marina"]
    var typePicker = UIPickerView()
    @IBOutlet weak var arcView : ArcView!
    
    @IBOutlet weak var duplicateViewHeight : NSLayoutConstraint!
    @IBOutlet weak var windViewHeight : NSLayoutConstraint!
    @IBOutlet weak var compassHeight : NSLayoutConstraint!
    
    @IBOutlet weak var prevNameView : UIView!
    @IBOutlet weak var prevNameLabel : UILabel!
    @IBOutlet weak var prevNameWidth : NSLayoutConstraint!
    @IBOutlet weak var nameField : UITextField!
    @IBOutlet weak var nameVerifyButton : VerifyButton!
    @IBOutlet weak var nameVerifyNo : UILabel!
    @IBOutlet weak var prevNameVerifyNo : UILabel!
    
    @IBOutlet weak var prevCoordinateView : UIView!
    @IBOutlet weak var prevCoordinateLabel : UILabel!
    @IBOutlet weak var prevCoordinateWidth : NSLayoutConstraint!
    @IBOutlet weak var coordinateFieldView : UIView!
    @IBOutlet weak var latitudeField : UITextField!
    @IBOutlet weak var longitudeField : UITextField!
    @IBOutlet weak var coordinateVerifyButton : VerifyButton!
    @IBOutlet weak var coordinateVerifyNo : UILabel!
    @IBOutlet weak var prevCoordinateVerifyNo : UILabel!

    @IBOutlet weak var prevTypeView : UIView!
    @IBOutlet weak var prevTypeLabel : UILabel!
    @IBOutlet weak var typeField : UITextField!
    @IBOutlet weak var typeVerifyButton : VerifyButton!
    @IBOutlet weak var typeVerifyNo : UILabel!
    @IBOutlet weak var prevTypeVerifyNo : UILabel!
    @IBOutlet weak var typeImage : UIImageView!
    @IBOutlet weak var prevTypeWidth : NSLayoutConstraint!
    
    @IBOutlet weak var descField : UITextView!
    @IBOutlet weak var descFieldHeight : NSLayoutConstraint!
    @IBOutlet weak var descVerifyButton : VerifyButton!
    @IBOutlet weak var descVerifyNo : UILabel!
    @IBOutlet weak var prevDescVerifyNo : UILabel!
    @IBOutlet weak var prevDescView : UIView!
    @IBOutlet weak var prevDescLabel : UILabel!
    @IBOutlet weak var prevDescWidth : NSLayoutConstraint!
    
    @IBOutlet weak var depthWidth : NSLayoutConstraint!
    @IBOutlet weak var depthField : UITextField!
    @IBOutlet weak var depthVerifyButton : VerifyButton!
    @IBOutlet weak var depthVerifyNo : UILabel!
    @IBOutlet weak var prevDepthVerifyNo : UILabel!
    @IBOutlet weak var prevDepthView : UIView!
    @IBOutlet weak var prevDepthLabel : UILabel!
    @IBOutlet weak var prevDepthWidth : NSLayoutConstraint!
     @IBOutlet weak var depthView : UIView!
    
    @IBOutlet weak var islandField : UITextField!
    @IBOutlet weak var islandVerifyButton : VerifyButton!
    @IBOutlet weak var islandVerifyNo : UILabel!
    @IBOutlet weak var prevIslandVerifyNo : UILabel!
    @IBOutlet weak var prevIslandView : UIView!
    @IBOutlet weak var prevIslandLabel : UILabel!
    @IBOutlet weak var prevIslandWidth : NSLayoutConstraint!
    
    @IBOutlet weak var cityField : UITextField!
    @IBOutlet weak var cityVerifyButton : VerifyButton!
    @IBOutlet weak var cityVerifyNo : UILabel!
    @IBOutlet weak var prevCityVerifyNo : UILabel!
    @IBOutlet weak var prevCityView : UIView!
    @IBOutlet weak var prevCityLabel : UILabel!
    @IBOutlet weak var prevCityWidth : NSLayoutConstraint!
    
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var photoViewheight :  NSLayoutConstraint!
    
    @IBOutlet weak var windNWVerifyButton : VerifyButton!
    @IBOutlet weak var windNWVerifyLabel: UILabel!
    @IBOutlet weak var windNWVerifyView : UIView!

    @IBOutlet weak var windNEVerifyButton : VerifyButton!
    @IBOutlet weak var windNEVerifyLabel: UILabel!
    @IBOutlet weak var windNEVerifyView : UIView!
    
    @IBOutlet weak var windNVerifyButton : VerifyButton!
    @IBOutlet weak var windNVerifyLabel: UILabel!
    @IBOutlet weak var windNVerifyView : UIView!
    
    @IBOutlet weak var windWVerifyButton : VerifyButton!
    @IBOutlet weak var windWVerifyLabel: UILabel!
    @IBOutlet weak var windWVerifyView : UIView!
    
    @IBOutlet weak var windSVerifyButton : VerifyButton!
    @IBOutlet weak var windSVerifyLabel: UILabel!
    @IBOutlet weak var windSVerifyView : UIView!
    
    @IBOutlet weak var windSEVerifyButton : VerifyButton!
    @IBOutlet weak var windSEVerifyLabel: UILabel!
    @IBOutlet weak var windSEVerifyView : UIView!
    
    @IBOutlet weak var windEVerifyButton : VerifyButton!
    @IBOutlet weak var windEVerifyLabel: UILabel!
    @IBOutlet weak var windEVerifyView : UIView!
    
    @IBOutlet weak var windSWVerifyButton : VerifyButton!
    @IBOutlet weak var windSWVerifyLabel: UILabel!
    @IBOutlet weak var windSWVerifyView : UIView!
    
     var loggedInUser : User!
    var currentPhotoViewHeight : CGFloat = 50.0
    var isSideMenuOpened = false
    var isFromSideMenu = false
    var revealViewController1 : SWRevealViewController!
    var isNewLocation = false
    var leftButton : UIBarButtonItem!
    var location : Location!
    var newAnnotation : FBAnnotation!
    var changesArray = [Versioning]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let maxWidth = UIScreen.main.bounds.size.width - 80
    var imageArray = [NewLocationImage]()
    var windDirArray = [Int16]()
    var prevWindDirArray = [Int16]()
    
    //MARK: - View Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        typePicker.delegate = self
        typeField.inputView = typePicker
        
        descField.layer.borderColor = UIColor.lightGray.cgColor
        descField.layer.borderWidth = 0.5
        descField.layer.cornerRadius = 5.0
        
        if(isFromSideMenu) {
            leftButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(openSideMenu(_ :)))
        }
        else {
            leftButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SettingsViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", (UserDefaults.standard.value(forKey: "LoggedInUser") as! String))
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! Array<User>
            loggedInUser = result.first
        } catch {}
                
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
            windEVerifyView.isHidden = true
            windWVerifyView.isHidden = true
            windSVerifyView.isHidden = true
            windNVerifyView.isHidden = true
            windNEVerifyView.isHidden = true
            windSEVerifyView.isHidden = true
            windSWVerifyView.isHidden = true
            windNWVerifyView.isHidden = true
        }
        else {
            self.navigationItem.title = "Edit"
            typePicker.selectRow(typeArray.index(of: (location.type?.type)!)!, inComponent: 0, animated: false)
            var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Versioning")
            request.predicate = NSPredicate(format: "forLocation == %@", location!)
            request.returnsObjectsAsFaults = false
            do {
                changesArray = try context.fetch(request) as! Array<Versioning>
            } catch {}
            windDirArray = [location.windSE?.windSE,location.windS?.windS,location.windSW?.windSW,location.windW?.windW,location.windNW?.windNW,location.windN?.windN,location.windNE?.windNE,location.windE?.windE] as! [Int16]
            
            prevWindDirArray = [location.windSE?.windSE,location.windS?.windS,location.windSW?.windSW,location.windW?.windW,location.windNW?.windNW,location.windN?.windN,location.windNE?.windNE,location.windE?.windE] as! [Int16]
            
            request = NSFetchRequest<NSFetchRequestResult>(entityName: "Images")
            request.predicate = NSPredicate(format: "forLocation == %@", location!)
            
            do {
                let images = try context.fetch(request) as! Array<Images>
                currentPhotoViewHeight = 50
                for i in 0..<images.count {
                    let imgView = LocationImage.instanceFromNibWithFrame(frame: CGRect(x: 0, y : Int(currentPhotoViewHeight), width : Int(UIScreen.main.bounds.size.width), height : 215)) as! LocationImage
                    imgView.locImage = images[i]
                    imgView.photoView.image =  UIImage(data: images[i].image! as Data)
                    imgView.duplicateLabel.text = "(0)"
                    imgView.verifyLabel.text = String(images[i].verifiedBy!.count)
                    imgView.verifyButton.addTarget(self, action: #selector(imageVerifyButtonTapped(_:)), for: .touchUpInside)
                    if(images[i].verifiedBy?.contains(loggedInUser))! {
                        imgView.verifyButton.isVerified = true
                    }
                    photoView.addSubview(imgView)
                    currentPhotoViewHeight = currentPhotoViewHeight + 215
                }
                photoViewheight.constant = currentPhotoViewHeight //CGFloat(50 + (images.count * 215))
            } catch {}
            
            if(location.windSE?.verifiedBy?.contains(loggedInUser))! {
                windSEVerifyButton.isVerified = true
            }
            if(location.windS?.verifiedBy?.contains(loggedInUser))! {
                windSVerifyButton.isVerified = true
            }
            if(location.windSW?.verifiedBy?.contains(loggedInUser))! {
                windSWVerifyButton.isVerified = true
            }
            if(location.windW?.verifiedBy?.contains(loggedInUser))! {
                windWVerifyButton.isVerified = true
            }
            if(location.windNW?.verifiedBy?.contains(loggedInUser))! {
                windNWVerifyButton.isVerified = true
            }
            if(location.windN?.verifiedBy?.contains(loggedInUser))! {
                windNVerifyButton.isVerified = true
            }
            if(location.windNE?.verifiedBy?.contains(loggedInUser))! {
                windNEVerifyButton.isVerified = true
            }
            if(location.name?.verifiedBy?.contains(loggedInUser))! {
                nameVerifyButton.isVerified = true
            }
            if(location.type?.verifiedBy?.contains(loggedInUser))! {
                typeVerifyButton.isVerified = true
            }
            if(location.city?.verifiedBy?.contains(loggedInUser))! {
                cityVerifyButton.isVerified = true
            }
            if(location.island?.verifiedBy?.contains(loggedInUser))! {
                islandVerifyButton.isVerified = true
            }
            if(location.depth?.verifiedBy?.contains(loggedInUser))! {
                depthVerifyButton.isVerified = true
            }
            if(location.coordinates?.verifiedBy?.contains(loggedInUser))! {
                coordinateVerifyButton.isVerified = true
            }
            if(location.locdescription?.verifiedBy?.contains(loggedInUser))! {
                descVerifyButton.isVerified = true
            }
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

        if isNewLocation {
            let annotation : FBAnnotation
            annotation = newAnnotation
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), span: span)
            //  let region  = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
            mapView.setRegion(region, animated: true)
        }
        else {
            let annotation = FBAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: (location.coordinates?.latitude)!, longitude: (location.coordinates?.longitude)!)
            annotation.title = location.name?.name
            annotation.type = location.type?.type
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude), span: span)
            //  let region  = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
            mapView.setRegion(region, animated: true)
        }
    
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
    
    //MARK: - ArcView Delegate
    
    func updateWindDirections(_ windArray: Array<Int16>) {
        windDirArray = windArray
    }
    
    //MARK: - Configure views
    
    func configureName() {
        if isNewLocation {
            prevNameView.isHidden = true
            nameField.isHidden = false
        }
        else {
            nameVerifyNo.text = String(location.name!.verifiedBy!.count)
            nameField.text = location.name?.name
            var filteredArray = changesArray.filter() {  $0.attributeId == "name" }
            if(filteredArray.count > 0) {
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevNameView.isHidden = false
                prevNameLabel.text = filteredArray.first?.previousValue
                if(prevNameLabel.text?.count == 0) {
                    prevNameLabel.text = " "
                }
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
             prevCoordinateView.isHidden = true
             prevCoordinateLabel.text = ""
        }
        else {
            coordinateVerifyNo.text = String(location.coordinates!.verifiedBy!.count)
            latitudeField.text = String(location.coordinates!.latitude)
            longitudeField.text = String(location.coordinates!.longitude)
            var filteredLatArray = changesArray.filter() {  $0.attributeId == "latitude" }
            var filteredLongArray = changesArray.filter() {  $0.attributeId == "longitude" }
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
            prevTypeView.isHidden = true
             prevTypeLabel.text = ""
        }
        else {
            typeVerifyNo.text = String(location.type!.verifiedBy!.count)
            typeField.text = location.type?.type
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
            if(location.type?.type == "Marina") {
                typeImage.image = UIImage(named: "marina")
            }
            else if (location.type?.type == "Buoy") {
                typeImage.image = UIImage(named: "bouy")
            }
            else if (location.type?.type == "Anchorage") {
                typeImage.image = UIImage(named: "anchor")
            }
        }
    }
    
    func configureDepth() {
        if isNewLocation {
            prevDepthView.isHidden = true
            prevDepthLabel.text = ""
        }
        else {
            depthVerifyNo.text = String(location.depth!.verifiedBy!.count)
            depthField.text = String(location.depth!.depth)
            var filteredArray = changesArray.filter() {  $0.attributeId == "depth" }
            if(filteredArray.count > 0) {
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
            prevDescView.isHidden = true
            descField.isHidden = false
        }
        else {
            descVerifyNo.text = String(location.locdescription!.verifiedBy!.count)
            descField.text = location.locdescription?.locDescription
            if((location.locdescription?.locDescription?.count)! > 0) {
                descFieldHeight.constant = descField.contentSize.height
            }
            else {
                descFieldHeight.constant = 60
            }
            var filteredArray = changesArray.filter() {  $0.attributeId == "description" }
            if(filteredArray.count > 0) {
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevDescView.isHidden = false
                prevDescLabel.text = filteredArray.first?.previousValue
                if(prevDescLabel.text?.count == 0) {
                     prevDescLabel.text = " "
                }
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
            prevCityView.isHidden = true
             prevCityLabel.text = ""
        }
        else {
            cityVerifyNo.text = String(location.city!.verifiedBy!.count)
             cityField.text = location.city?.city
            var filteredArray = changesArray.filter() {  $0.attributeId == "city" }
            if(filteredArray.count > 0) {
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevCityView.isHidden = false
                prevCityLabel.text = filteredArray.first?.previousValue
                if(prevCityLabel.text?.count == 0) {
                    prevCityLabel.text = " "
                }
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
            prevIslandView.isHidden = true
             prevIslandLabel.text = ""
        }
        else {
            islandVerifyNo.text = String(location.island!.verifiedBy!.count)
             islandField.text = location.island?.island
            var filteredArray = changesArray.filter() {  $0.attributeId == "island" }
            if(filteredArray.count > 0) {
                //  print(filteredArray)
                filteredArray = filteredArray.sorted(by: {
                    $0.timeOfChange?.compare($1.timeOfChange! as Date) == .orderedDescending
                })
                prevIslandView.isHidden = false
                prevIslandLabel.text = filteredArray.first?.previousValue
                if(prevIslandLabel.text?.count == 0) {
                    prevIslandLabel.text = " "
                }
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
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func imageVerifyButtonTapped(_ sender : VerifyButton) {
        let imgView = sender.superview as! LocationImage
         sender.isVerified =  !sender.isVerified
        if(sender.isVerified) {
             imgView.verifyLabel.text = String(Int(imgView.verifyLabel.text!)! + 1)
            imgView.locImage.addToVerifiedBy(loggedInUser)
        }
        else {
            imgView.verifyLabel.text = String(Int(imgView.verifyLabel.text!)! - 1)
            imgView.locImage.removeFromVerifiedBy(loggedInUser)
        }
        
    }
    
    @IBAction func verifyButtonTapped(_ sender : VerifyButton) {
        
        if(!isNewLocation) {
            sender.isVerified =  !sender.isVerified
            
            if(sender.isVerified) {
                switch sender.tag {
                case 1:
                    coordinateVerifyNo.text = String(Int(coordinateVerifyNo.text!)! + 1)
                    location.coordinates?.addToVerifiedBy(loggedInUser)
                case 2:
                    typeVerifyNo.text = String(Int(typeVerifyNo.text!)! + 1)
                    location.type?.addToVerifiedBy(loggedInUser)
                case 3:
                    nameVerifyNo.text = String(Int(nameVerifyNo.text!)! + 1)
                    location.name?.addToVerifiedBy(loggedInUser)
                case 4:
                    islandVerifyNo.text = String(Int(islandVerifyNo.text!)! + 1)
                    location.island?.addToVerifiedBy(loggedInUser)
                case 5:
                    cityVerifyNo.text = String(Int(cityVerifyNo.text!)! + 1)
                    location.city?.addToVerifiedBy(loggedInUser)
                case 6:
                    depthVerifyNo.text = String(Int(depthVerifyNo.text!)! + 1)
                    location.depth?.addToVerifiedBy(loggedInUser)
                case 7:
                    descVerifyNo.text = String(Int(descVerifyNo.text!)! + 1)
                    location.locdescription?.addToVerifiedBy(loggedInUser)
                case 10:
                    windSEVerifyLabel.text = String(Int(windSEVerifyLabel.text!)! + 1)
                    location.windSE?.addToVerifiedBy(loggedInUser)
                case 11:
                    windSVerifyLabel.text = String(Int(windSVerifyLabel.text!)! + 1)
                    location.windS?.addToVerifiedBy(loggedInUser)
                case 12:
                    windSWVerifyLabel.text = String(Int(windSWVerifyLabel.text!)! + 1)
                    location.windSW?.addToVerifiedBy(loggedInUser)
                case 13:
                    windWVerifyLabel.text = String(Int(windWVerifyLabel.text!)! + 1)
                    location.windW?.addToVerifiedBy(loggedInUser)
                case 14:
                    windNWVerifyLabel.text = String(Int(windNWVerifyLabel.text!)! + 1)
                    location.windNW?.addToVerifiedBy(loggedInUser)
                case 15:
                    windNVerifyLabel.text = String(Int(windNVerifyLabel.text!)! + 1)
                    location.windN?.addToVerifiedBy(loggedInUser)
                case 16:
                    windNEVerifyLabel.text = String(Int(windNEVerifyLabel.text!)! + 1)
                    location.windNE?.addToVerifiedBy(loggedInUser)
                case 17:
                    windEVerifyLabel.text = String(Int(windEVerifyLabel.text!)! + 1)
                    location.windE?.addToVerifiedBy(loggedInUser)
                default:
                    break
                }
            }
            else {
                switch sender.tag {
                case 1:
                    coordinateVerifyNo.text = String(Int(coordinateVerifyNo.text!)! - 1)
                    location.coordinates?.removeFromVerifiedBy(loggedInUser)
                    
                case 2:
                    typeVerifyNo.text = String(Int(typeVerifyNo.text!)! - 1)
                    location.type?.removeFromVerifiedBy(loggedInUser)
                case 3:
                    nameVerifyNo.text = String(Int(nameVerifyNo.text!)! - 1)
                    location.name?.removeFromVerifiedBy(loggedInUser)
                case 4:
                    islandVerifyNo.text = String(Int(islandVerifyNo.text!)! - 1)
                    location.island?.removeFromVerifiedBy(loggedInUser)
                case 5:
                    cityVerifyNo.text = String(Int(cityVerifyNo.text!)! - 1)
                    location.city?.removeFromVerifiedBy(loggedInUser)
                case 6:
                    depthVerifyNo.text = String(Int(depthVerifyNo.text!)! - 1)
                    location.depth?.removeFromVerifiedBy(loggedInUser)
                case 7:
                    descVerifyNo.text = String(Int(descVerifyNo.text!)! - 1)
                    location.locdescription?.removeFromVerifiedBy(loggedInUser)
                case 10:
                    windSEVerifyLabel.text = String(Int(windSEVerifyLabel.text!)! - 1)
                    location.windSE?.removeFromVerifiedBy(loggedInUser)
                case 11:
                    windSVerifyLabel.text = String(Int(windSVerifyLabel.text!)! - 1)
                    location.windS?.removeFromVerifiedBy(loggedInUser)
                case 12:
                    windSWVerifyLabel.text = String(Int(windSWVerifyLabel.text!)! - 1)
                    location.windSW?.removeFromVerifiedBy(loggedInUser)
                case 13:
                    windWVerifyLabel.text = String(Int(windWVerifyLabel.text!)! - 1)
                    location.windW?.removeFromVerifiedBy(loggedInUser)
                case 14:
                    windNWVerifyLabel.text = String(Int(windNWVerifyLabel.text!)! - 1)
                    location.windNW?.removeFromVerifiedBy(loggedInUser)
                case 15:
                    windNVerifyLabel.text = String(Int(windNVerifyLabel.text!)! - 1)
                    location.windN?.removeFromVerifiedBy(loggedInUser)
                case 16:
                    windNEVerifyLabel.text = String(Int(windNEVerifyLabel.text!)! - 1)
                    location.windNE?.removeFromVerifiedBy(loggedInUser)
                case 17:
                    windEVerifyLabel.text = String(Int(windEVerifyLabel.text!)! - 1)
                    location.windE?.removeFromVerifiedBy(loggedInUser)
                default:
                    break
                }
            }
            
        }
       
       

    }
    
    @IBAction func saveButtonTapped(_ sender : Any) {
        
        if(latitudeField.text?.count == 0 || longitudeField.text?.count == 0) {
            let alertMessage: UIAlertController = self.showAlert(withTitle: "ERROR", andMessage: "Please enter coordinates of the location properly")
            self.present(alertMessage, animated: true, completion: nil)
            return
        }
        
        if(isNewLocation) {
            
            // Creatr Location Object
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
            let newLoc = NSManagedObject(entity: entity!, insertInto: context) as! Location
            
            
            let newCoord = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Coordinates", in: context)!, insertInto: context) as! Coordinates
            newCoord.latitude = Double(latitudeField.text!)!
            newCoord.longitude = Double(longitudeField.text!)!
            
            let newName = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Name", in: context)!, insertInto: context) as! Name
            newName.name = nameField.text
            
            let newType = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Type", in: context)!, insertInto: context) as! Type
            newType.type = typeField.text
            
            let newCity = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "City", in: context)!, insertInto: context) as! City
            newCity.city = cityField.text
            
            let newIsland = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Island", in: context)!, insertInto: context) as! Island
            newIsland.island = islandField.text
            
            let newDesc = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Description", in: context)!, insertInto: context) as! Description
            newDesc.locDescription = descField.text
            
            let newDepth = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Depth", in: context)!, insertInto: context) as! Depth
            if((depthField.text?.count)! > 0) {
                newDepth.depth = Double(depthField.text!)!
            }
            else {
                newDepth.depth = 0.0
            }
            
            let newWindW = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindW", in: context)!, insertInto: context) as! WindW
            newWindW.windW = windDirArray[3]
            
            let newWindE = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindE", in: context)!, insertInto: context) as! WindE
            newWindE.windE = windDirArray[7]
            
            let newWindN = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindN", in: context)!, insertInto: context) as! WindN
            newWindN.windN = windDirArray[5]
            
            let newWindS = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindS", in: context)!, insertInto: context) as! WindS
            newWindS.windS = windDirArray[1]
            
            let newWindNW = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindNW", in: context)!, insertInto: context) as! WindNW
            newWindNW.windNW = windDirArray[4]
            
            let newWindSW = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindSW", in: context)!, insertInto: context) as! WindSW
            newWindSW.windSW = windDirArray[2]
            
            let newWindNE = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindNE", in: context)!, insertInto: context) as! WindNE
            newWindNE.windNE = windDirArray[6]
            
            let newWindSE = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindSE", in: context)!, insertInto: context) as! WindSE
            newWindSE.windSE = windDirArray[0]
            
            newName.forLocation = newLoc
            newCity.forLocation = newLoc
            newType.forLocation = newLoc
            newIsland.forLocation = newLoc
            newDepth.forLocation = newLoc
            newDesc.forLocation = newLoc
            newWindW.forLocation = newLoc
            newWindE.forLocation = newLoc
            newWindN.forLocation = newLoc
            newWindW.forLocation = newLoc
            newWindS.forLocation = newLoc
            newWindNE.forLocation = newLoc
            newWindNW.forLocation = newLoc
            newWindSE.forLocation = newLoc
            newWindSW.forLocation = newLoc
            newCoord.forLocation = newLoc
            
            for i in 0..<imageArray.count {
                // Create Images Objects
                let entity = NSEntityDescription.entity(forEntityName: "Images", in: context)
                let newImg = NSManagedObject(entity: entity!, insertInto: context) as! Images
                newImg.image = UIImageJPEGRepresentation((imageArray[i] as NewLocationImage).locImage, 0.5)! as NSData
                newImg.forLocation = newLoc
            }
        }
        else {
            
            for i in 0..<imageArray.count {
                // Create Images Objects
                let entity = NSEntityDescription.entity(forEntityName: "Images", in: context)
                let newImg = NSManagedObject(entity: entity!, insertInto: context) as! Images
                newImg.image = UIImageJPEGRepresentation((imageArray[i] as NewLocationImage).locImage, 0.5)! as NSData
                newImg.forLocation = location
            }
            
            
            if(nameField.text != location.name?.name) {
                let newChange = createNewVersioningRecord()
                newChange.attributeId = "name"
                newChange.previousValue = location.name?.name
                newChange.verification = Int16(nameVerifyNo.text!)!
                location.name?.name = nameField.text
                location.name?.removeFromVerifiedBy((location.name?.verifiedBy)!)
            }
            
            if(islandField.text != location.island?.island) {
                let newChange = createNewVersioningRecord()
                newChange.attributeId = "island"
                newChange.previousValue = location.island?.island
                newChange.verification = Int16(islandVerifyNo.text!)!
                location.island?.island = islandField.text
                location.island?.removeFromVerifiedBy((location.island?.verifiedBy)!)
            }
            
            if(cityField.text != location.city?.city) {
                let newChange = createNewVersioningRecord()
                newChange.attributeId = "city"
                newChange.previousValue = location.city?.city
                newChange.verification = Int16(cityVerifyNo.text!)!
                location.city?.city = cityField.text
                location.city?.removeFromVerifiedBy((location.city?.verifiedBy)!)
            }
            
            if(typeField.text != location.type?.type) {
                let newChange = createNewVersioningRecord()
                newChange.attributeId = "type"
                newChange.previousValue = location.type?.type
                newChange.verification = Int16(typeVerifyNo.text!)!
                location.type?.type = typeField.text
                location.type?.removeFromVerifiedBy((location.type?.verifiedBy)!)
            }
            
            if((depthField.text?.count)! == 0) {
               depthField.text = "0.0"
            }
            
            if(Double(depthField.text!) != location.depth?.depth) {
                let newChange = createNewVersioningRecord()
                newChange.attributeId = "depth"
                newChange.previousValue = String(location.depth!.depth)
                newChange.verification = Int16(depthVerifyNo.text!)!
                if((depthField.text?.count)! > 0) {
                    location.depth?.depth = Double(depthField.text!)!
                }
                else {
                    location.depth?.depth = 0.0
                }
                location.depth?.removeFromVerifiedBy((location.depth?.verifiedBy)!)
            }
            
            if(descField.text != location.locdescription?.locDescription) {
                let newChange = createNewVersioningRecord()
                newChange.attributeId = "description"
                newChange.previousValue = location.locdescription?.locDescription
                newChange.verification = Int16(descVerifyNo.text!)!
                location.locdescription?.locDescription = descField.text
                location.locdescription?.removeFromVerifiedBy((location.locdescription?.verifiedBy)!)
            }
            
            if(latitudeField.text != String(location.coordinates!.latitude) || longitudeField.text != String(location.coordinates!.longitude)) {

                let newChange = createNewVersioningRecord()
                newChange.attributeId = "latitude"
                newChange.previousValue = String(location.coordinates!.latitude)
                newChange.verification = Int16(coordinateVerifyNo.text!)!
                location.coordinates?.latitude = Double(latitudeField.text!)!
                
                let newChange2 = createNewVersioningRecord()
                newChange2.attributeId = "longitude"
                newChange2.previousValue = String(location.coordinates!.longitude)
                newChange2.verification = Int16(coordinateVerifyNo.text!)!
                location.coordinates?.longitude = Double(longitudeField.text!)!
                
                location.coordinates?.removeFromVerifiedBy((location.coordinates?.verifiedBy)!)
            }
            
            for i in 0..<windDirArray.count {
                if(prevWindDirArray[i] != windDirArray[i]) {
                    switch (i)
                    {
                        case 0:
                            let newChange = createNewVersioningRecord()
                            newChange.attributeId = "windSE"
                            newChange.previousValue = String(location.windSE!.windSE)
                            newChange.verification = Int16(windSEVerifyLabel.text!)!
                            location.windSE?.removeFromVerifiedBy((location.windSE?.verifiedBy)!)
                            location.windSE?.windSE = windDirArray[i]
                        
                        case 1:
                            location.windS?.windS = windDirArray[i]
                        case 2:
                            location.windSW?.windSW = windDirArray[i]
                        case 3:
                            location.windW?.windW = windDirArray[i]
                        case 4:
                            location.windNW?.windNW = windDirArray[i]
                        case 5:
                            location.windN?.windN = windDirArray[i]
                        case 6:
                            location.windNE?.windNE = windDirArray[i]
                        case 7:
                            location.windE?.windE = windDirArray[i]
                        
                    default:
                        break
                    }
                    
                }
            }
            
        }
        
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
    
    func createNewVersioningRecord() -> Versioning {
        let entity = NSEntityDescription.entity(forEntityName: "Versioning", in: context)
        let newChange = NSManagedObject(entity: entity!, insertInto: context) as! Versioning
        newChange.timeOfChange = Date() as NSDate
        newChange.forLocation = location
        return newChange
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
    
    // MARK: - Textfield delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(!isNewLocation) {
            if(textField == latitudeField || textField == longitudeField) {
                
                if((Double(latitudeField.text!) != location.coordinates?.latitude)  || (Double(longitudeField.text!) != location.coordinates?.longitude)) {
                    coordinateVerifyNo.isHidden = true
                    coordinateVerifyButton.isHidden = true
                }
                else {
                    coordinateVerifyNo.isHidden = false
                    coordinateVerifyButton.isHidden = false
                }
            }
            else if (textField == nameField) {
                if(nameField.text! != location.name?.name) {
                    nameVerifyNo.isHidden = true
                    nameVerifyButton.isHidden = true
                }
                else {
                    nameVerifyNo.isHidden = false
                    nameVerifyButton.isHidden = false
                }
            }
            else if (textField == typeField) {
                if(typeField.text! != location.type?.type) {
                    typeVerifyNo.isHidden = true
                    typeVerifyButton.isHidden = true
                }
                else {
                    typeVerifyNo.isHidden = false
                    typeVerifyButton.isHidden = false
                }
            }
            else if (textField == islandField) {
                if(islandField.text! != location.island?.island) {
                    islandVerifyNo.isHidden = true
                    islandVerifyButton.isHidden = true
                }
                else {
                    islandVerifyNo.isHidden = false
                    islandVerifyButton.isHidden = false
                }
            }
            else if (textField == cityField) {
                if(cityField.text! != location.city?.city) {
                    cityVerifyNo.isHidden = true
                    cityVerifyButton.isHidden = true
                }
                else {
                    cityVerifyNo.isHidden = false
                    cityVerifyButton.isHidden = false
                }
            }
            else if (textField == depthField) {
                if(Double(depthField.text!) != location.depth?.depth) {
                    depthVerifyNo.isHidden = true
                    depthVerifyButton.isHidden = true
                }
                else {
                    depthVerifyNo.isHidden = false
                    depthVerifyButton.isHidden = false
                }
            }
        }
        
       
    }
    
    func textViewDidEndEditing(_ textview: UITextView) {
        if (textview == descField) {
            if(descField.text! != location.locdescription?.locDescription) {
                descVerifyNo.isHidden = true
                descVerifyButton.isHidden = true
            }
            else {
                descVerifyNo.isHidden = false
                descVerifyButton.isHidden = false
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
        
        let img : NewLocationImage = NewLocationImage(frame: CGRect(x: 0, y:currentPhotoViewHeight + CGFloat(imageArray.count * 180), width:self.view.frame.size.width, height: 180))
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
        
     //   var y : CGFloat = 50.0
        for i in index!..<imageArray.count {
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
    
   
}
