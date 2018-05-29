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
            let path = Bundle.main.path(forResource: "Location", ofType: "csv") //Hard coded these in
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
//         print(prevPageIndex)
//            print(currentPageIndex)
//         print(self.lastContentOffset)
//        print(scrollView.contentOffset.x)

    }

    func parserDidBeginDocument(_ parser: CHCSVParser) {
        
    }
    
    func parserDidEndDocument(_ parser: CHCSVParser!) {
        
        print(locationData.count)
        
        for i in 0..<1000 {
       //     print(i)
//            if(i > 1120) {
//                print(locationData[i])
//            }
            let entity = NSEntityDescription.entity(forEntityName: "Location", in: context)
            let newLoc = NSManagedObject(entity: entity!, insertInto: context) as! Location
            newLoc.windE = (locationData[i]["0"]!).toBool()!
            newLoc.windN = (locationData[i]["1"]!).toBool()!
            newLoc.windS = (locationData[i]["4"]!).toBool()!
            newLoc.windW = (locationData[i]["7"]!).toBool()!
            newLoc.windSW = (locationData[i]["6"]!).toBool()!
            newLoc.windNW = (locationData[i]["3"]!).toBool()!
            newLoc.windSE = (locationData[i]["5"]!).toBool()!
            newLoc.windNE = (locationData[i]["2"]!).toBool()!
            newLoc.type = locationData[i]["16"]!
            newLoc.country = locationData[i]["12"]!
            newLoc.city = locationData[i]["14"]!
            newLoc.latitude = Double(locationData[i]["9"]!)!
            newLoc.longitude = Double(locationData[i]["10"]!)!
            newLoc.locDescription = locationData[i]["15"]!
            newLoc.island = locationData[i]["11"]!
            newLoc.name = locationData[i]["13"]!
            newLoc.depth = Double(locationData[i]["8"]!)!
            do {
                try context.save()
                print("saved")
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
        
        dict["\(fieldIndex)"] =  field as String!
    }
    
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}

