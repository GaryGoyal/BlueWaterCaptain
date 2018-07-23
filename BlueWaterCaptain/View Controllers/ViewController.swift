//
//  ViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/24/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class ViewController: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate, CHCSVParserDelegate {
    
    var locationData = [Dictionary<String, String>]()
    var dict : Dictionary<String, String>!
    
    
    @IBOutlet weak var introScrollview: UIScrollView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var pageIndex1: UIImageView!
    @IBOutlet weak var pageIndex2: UIImageView!
    @IBOutlet weak var pageIndex3: UIImageView!
    var lastContentOffset : CGFloat!
    var locationManager: CLLocationManager!
    var currentPageIndex = 0
    var prevPageIndex = -1
    var pageControlArray : Array<UIImageView>!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControlArray = [pageIndex1, pageIndex2, pageIndex3]
        lastContentOffset = introScrollview.contentOffset.x
        yesButton.layer.borderColor = UIColor.white.cgColor
        yesButton.layer.borderWidth = 2.0;
        yesButton.layer.cornerRadius = 5.0;
        
        laterButton.layer.shadowOffset = CGSize(width : 1, height : 5)
        laterButton.layer.shadowColor = UIColor.darkGray.cgColor
        laterButton.layer.shadowOpacity = 0.3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        
       
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        introScrollview.contentSize = CGSize(width: 3 * self.view.frame.size.width, height: self.view.frame.size.height)
        
        if(UserDefaults.standard.bool(forKey: "isFirstTime") == true){
            performSegue(withIdentifier: "mapSegue", sender: self)
        }
        else {
            let path = Bundle.main.path(forResource: "Locations", ofType: "csv") //Hard coded these in
            let url = URL.init(fileURLWithPath: path!)
            let parser : CHCSVParser! = CHCSVParser.init(contentsOfDelimitedURL: url, delimiter: ",".utf16.first!)
            
            parser.delegate = self
            parser.parse()
        }
    }
    
    
    @IBAction func yesButtonTapped(_ sender : Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
          //  manager.requestWhenInUseAuthorization()
             print("not determined")
            break
        case .authorizedWhenInUse:
            // If authorized when in use
             print("authorizedWhenInUse")
            manager.startUpdatingLocation()
              goToMapScreen()
            break
        case .authorizedAlways:
            print("Great, location services are now enabled! Tap 'OK' to continue")
            // If always authorized
            manager.startUpdatingLocation()
             goToMapScreen()
            break
        case .restricted:
            print("restricted")
             goToMapScreen()// If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            print("denied")
            goToMapScreen()
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
     @IBAction func laterButtonTapped(_ sender : Any) {
       goToMapScreen()
    }

    func goToMapScreen() {
        if(UserDefaults.standard.bool(forKey: "isFirstTime") != true){
            UserDefaults.standard.set(true, forKey: "isFirstTime")
            performSegue(withIdentifier: "mapSegue", sender: self)
             UserDefaults.standard.set("Decimal Degree D.D°", forKey: "coordinateFormat")
           //  UserDefaults.standard.set("mm/dd/yy", forKey: "dateFormat")
           //  UserDefaults.standard.set("24 Hour", forKey: "timeFormat")
             UserDefaults.standard.set("metric system (metre)", forKey: "depthFormat")
            UserDefaults.standard.set(45.433635, forKey: "defaultLatitude")
            UserDefaults.standard.set(12.337164, forKey: "defaultLongitude")
            UserDefaults.standard.set(2.0, forKey: "depthValue")
             UserDefaults.standard.set([-1,-1,-1,-1,-1,-1,-1,-1], forKey: "windDirFilter")
            UserDefaults.standard.set(["Anchorage","Buoy","Marina"], forKey: "types")
             UserDefaults.standard.synchronize()
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView : UIScrollView)
    {
        self.lastContentOffset = scrollView.contentOffset.x;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView : UIScrollView)
    {

        if (self.lastContentOffset > scrollView.contentOffset.x) {
             prevPageIndex = currentPageIndex
             currentPageIndex = currentPageIndex - 1
            (pageControlArray[prevPageIndex] as UIImageView).image = UIImage(named: "pageOff")
            (pageControlArray[currentPageIndex] as UIImageView).image = UIImage(named: "pageOn")
        } else if (self.lastContentOffset < scrollView.contentOffset.x) {
            prevPageIndex = currentPageIndex
            currentPageIndex = currentPageIndex + 1
            (pageControlArray[prevPageIndex] as UIImageView).image = UIImage(named: "pageOff")
            (pageControlArray[currentPageIndex] as UIImageView).image = UIImage(named: "pageOn")
        }
    }

    func parserDidBeginDocument(_ parser: CHCSVParser) {
        
    }
    
    func parserDidEndDocument(_ parser: CHCSVParser!) {
        
        let user = NSManagedObject(entity: (NSEntityDescription.entity(forEntityName: "User", in: context))!, insertInto: context) as! User
        user.username = "Ferdinand"
        user.userId = "1"
        if let imageData = UIImageJPEGRepresentation(UIImage(named : "profile")!, 1) {
            user.profilePic = imageData as NSData
        }
        else {
            print("jpg error")
        }
        
        UserDefaults.standard.set(user.userId, forKey: "LoggedInUser")
        UserDefaults.standard.synchronize()

        for i in 0..<locationData.count {
            print(i)
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
            let newLoc = NSManagedObject(entity: entity!, insertInto: context) as! Location
            
            let newCoord = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Coordinates", in: context)!, insertInto: context) as! Coordinates
            newCoord.latitude = Double(locationData[i]["9"]!)!
            newCoord.longitude = Double(locationData[i]["10"]!)!
            
            let newName = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Name", in: context)!, insertInto: context) as! Name
            newName.name = locationData[i]["13"]!
            
            let newType = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Type", in: context)!, insertInto: context) as! Type
            newType.type = locationData[i]["16"]!
            
            let newCity = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "City", in: context)!, insertInto: context) as! City
            newCity.city = locationData[i]["14"]!
    
            let newIsland = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Island", in: context)!, insertInto: context) as! Island
            newIsland.island = locationData[i]["11"]!
            
            let newDesc = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Description", in: context)!, insertInto: context) as! Description
            newDesc.locDescription = locationData[i]["15"]!
            
            let newDepth = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "Depth", in: context)!, insertInto: context) as! Depth
            newDepth.depth =  Double(locationData[i]["8"]!)!
            
            let newWindW = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindW", in: context)!, insertInto: context) as! WindW
            newWindW.windW = Int16(locationData[i]["7"]!)!
            
            let newWindE = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindE", in: context)!, insertInto: context) as! WindE
            newWindE.windE = Int16(locationData[i]["0"]!)!
            
            let newWindN = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindN", in: context)!, insertInto: context) as! WindN
            newWindN.windN = Int16(locationData[i]["1"]!)!
            
            let newWindS = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindS", in: context)!, insertInto: context) as! WindS
            newWindS.windS = Int16(locationData[i]["4"]!)!
            
            let newWindNW = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindNW", in: context)!, insertInto: context) as! WindNW
            newWindNW.windNW = Int16(locationData[i]["3"]!)!
            
            let newWindSW = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindSW", in: context)!, insertInto: context) as! WindSW
            newWindSW.windSW = Int16(locationData[i]["6"]!)!
            
            let newWindNE = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindNE", in: context)!, insertInto: context) as! WindNE
            newWindNE.windNE = Int16(locationData[i]["2"]!)!
            
            let newWindSE = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "WindSE", in: context)!, insertInto: context) as! WindSE
            newWindSE.windSE = Int16(locationData[i]["5"]!)!
            
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
      
            do {
                try context.save()
                //print("saved")
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func parser(_ parser: CHCSVParser!, didBeginLine recordNumber: UInt) {
        dict = [String : String]()
      //  print(recordNumber)
        
    }
    
    func parser(_ parser: CHCSVParser!, didEndLine recordNumber: UInt) {
        
     //  print(recordNumber)
        locationData.append(dict)
        dict=nil;
         //print(locationData.count)
    }
    
    func parser(_ parser: CHCSVParser!, didReadField field: String!, at fieldIndex: Int) {
        
        dict["\(fieldIndex)"] =  field as String?
    }
    
}

extension Int {
    func toBool() -> Bool? {
        switch self {
        case 1:
            return true
        case 0:
            return false
        default:
            return nil
        }
    }
}

