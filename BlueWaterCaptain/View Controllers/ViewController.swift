//
//  ViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/24/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {
    
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
            performSegue(withIdentifier: "directMapSegue", sender: self)
        }
       
    }
    
    
    @IBAction func yesButtonTapped(_ sender : Any) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.authorizationStatus() != .authorizedAlways     // Check authorization for location tracking
        {
            locationManager.requestAlwaysAuthorization()                    // LocationManager will callbackdidChange... once user responds
        } else {
            locationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
             print("authorizedWhenInUse")
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            print("Great, location services are now enabled! Tap 'OK' to continue")
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            print("restricted")// If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            print("denied")
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
     @IBAction func laterButtonTapped(_ sender : Any) {
        
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

}

