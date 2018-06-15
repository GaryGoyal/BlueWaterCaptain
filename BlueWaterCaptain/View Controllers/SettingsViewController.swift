//
//  SettingsViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/27/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
     @IBOutlet weak var nameLabel: UILabel!
     @IBOutlet weak var degreeLabel: UITextField!
  //  @IBOutlet weak var dateLabel : UITextField!
  //   @IBOutlet weak var timeLabel : UITextField!
    @IBOutlet weak var depthLabel: UITextField!
     @IBOutlet weak var nameField: UITextField!
     @IBOutlet weak var profileImg: UIImageView!
     @IBOutlet weak var locationGrantedImg: UIImageView!
     @IBOutlet weak var notificationGrantedImg: UIImageView!
    @IBOutlet weak var locationDisabledButton: UIButton!
    @IBOutlet weak var notificationDisabledButton: UIButton!
     @IBOutlet weak var nameEditButton: UIButton!
     @IBOutlet weak var imgEditButton: UIButton!
     @IBOutlet weak var depthEditButton: UIButton!
   //  @IBOutlet weak var timeEditButton: UIButton!
   //  @IBOutlet weak var dateEditButton: UIButton!
     @IBOutlet weak var degreeEditButton: UIButton!
  //  var degreeArray = ["DecDeg","DecMin","DecMinSec"]
  //  var degreeDict = ["DecDeg" : "Decimal Degree D.D°","DecMin" : "Decimal Minutes D° M.M′","DecMinSec": "Decimal Seconds D° M′ S.S"]
    var degreeArray = ["Decimal Degree D.D°","Decimal Minutes D° M.M′","Decimal Seconds D° M′ S.S"]
    var degreePicker = UIPickerView()
//    var timeArray = ["24 Hour","12 Hour"]
//    var timePicker = UIPickerView()
//    var dateArray = ["mm/dd/yy","dd.mm.yy"]
//    var dateFormatPicker = UIPickerView()
    var depthArray = ["metric system (metre)","imperial system (feet)"]
    var depthPicker = UIPickerView()
     var isSideMenuOpened = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.tableView.contentInsetAdjustmentBehavior = .never
      //  self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)

        degreePicker.delegate = self
        degreeLabel.inputView = degreePicker
//        dateFormatPicker.delegate = self
//        dateLabel.inputView = dateFormatPicker
//        timePicker.delegate = self
//        timeLabel.inputView = timePicker
        depthPicker.delegate = self
        depthLabel.inputView = depthPicker
        profileImg.layer.cornerRadius = 35
        profileImg.clipsToBounds = true
        
       // let selectedCoord = UserDefaults.standard.value(forKey: "coordinateFormat") as! String
        degreePicker.selectRow(degreeArray.index(of: UserDefaults.standard.value(forKey: "coordinateFormat") as! String)!, inComponent: 0, animated: false)
      //  dateFormatPicker.selectRow(dateArray.index(of: UserDefaults.standard.value(forKey: "dateFormat") as! String)!, inComponent: 0, animated: false)
      //  timePicker.selectRow(timeArray.index(of: UserDefaults.standard.value(forKey: "timeFormat") as! String)!, inComponent: 0, animated: false)
        depthPicker.selectRow(depthArray.index(of: UserDefaults.standard.value(forKey: "depthFormat") as! String)!, inComponent: 0, animated: false)
        
        degreeLabel.text = UserDefaults.standard.value(forKey: "coordinateFormat") as? String
       // timeLabel.text = UserDefaults.standard.value(forKey: "timeFormat") as? String
       // dateLabel.text = UserDefaults.standard.value(forKey: "dateFormat") as? String
        depthLabel.text = UserDefaults.standard.value(forKey: "depthFormat") as? String
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(SettingsViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        checkForPermissions()

    }
    
   @objc func applicationBecameActive(_ notify : Notification) {
        checkForPermissions()
    }
    
    func checkForPermissions() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .denied {
                DispatchQueue.main.async(execute: { () -> Void in
                        self.notificationGrantedImg.isHidden = true
                    self.notificationDisabledButton.isHidden = false
                })
            }
            else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.notificationGrantedImg.isHidden = false
                    self.notificationDisabledButton.isHidden = true
                })
            }
        })
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                DispatchQueue.main.async(execute: { () -> Void in
                        self.locationGrantedImg.isHidden = true
                    self.locationDisabledButton.isHidden = false
                })
            case .authorizedAlways, .authorizedWhenInUse:
                DispatchQueue.main.async(execute: { () -> Void in
                    self.locationGrantedImg.isHidden = false
                    self.locationDisabledButton.isHidden = true
                })
            }
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
                self.locationGrantedImg.isHidden = true
                self.locationDisabledButton.isHidden = false
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SettingsViewController.applicationBecameActive(_:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section == 0 && indexPath.row == 1) {
            return 90
        }
        else {
            return 70
        }
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

    @IBAction func nameEditButtonTapped(_ sender : Any) {
        nameField.isHidden = false
        nameField.text = nameLabel.text
        nameLabel.isHidden = true
        nameField.becomeFirstResponder()
    }

    @IBAction func degreeEditButtonTapped(_ sender : Any) {
        degreeLabel.isEnabled = true
        degreeLabel.becomeFirstResponder()
    }

    @IBAction func depthEditButtonTapped(_ sender : Any) {
        depthLabel.isEnabled = true
        depthLabel.becomeFirstResponder()
    }

 /*   @IBAction func dateEditButtonTapped(_ sender : Any) {
        dateLabel.isEnabled = true
        dateLabel.becomeFirstResponder()
    }

    @IBAction func timeEditButtonTapped(_ sender : Any) {
        timeLabel.isEnabled = true
        timeLabel.becomeFirstResponder()
    }*/

    @IBAction func imgEditButtonTapped(_ sender : Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { (action) -> Void in
            self.imageFromCamera()
        })
        let  libraryButton = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default, handler: { (action) -> Void in
            self.imageFromPhotoLibrary()
        })
        let cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
            actionSheet.dismiss(animated: true, completion: nil)
        })
        actionSheet.addAction(cameraButton)
        actionSheet.addAction(libraryButton)
        actionSheet.addAction(cancelButton)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imageFromPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    @IBAction func goToSettings(_ sender : Any) {
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                // Checking for setting is opened or not
                print("Setting is opened: \(success)")
            })
        }
    }
    
    
    // MARK: - Textfield delegates
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameField.isHidden = true
        nameLabel.text = nameField.text
        nameLabel.isHidden = false
        nameField.resignFirstResponder()
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
        if pickerView == degreePicker {
             return degreeArray.count
        }
    /*    else if pickerView == dateFormatPicker {
            return dateArray.count
        }
        else if pickerView == timePicker {
            return timeArray.count
        }*/
        else if pickerView == depthPicker {
            return depthArray.count
        }
        else {
            return 0
        }
       
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == degreePicker {
                   return degreeArray[row]
        }
     /*   else if pickerView == dateFormatPicker {
                    return dateArray[row]
        }
        else if pickerView == timePicker {
                   return timeArray[row]
        }*/
        else if pickerView == depthPicker {
                    return depthArray[row]
        }
        else {
            return ""
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == degreePicker {
                    degreeLabel.text = degreeArray[row]
             UserDefaults.standard.set(degreeArray[row], forKey: "coordinateFormat")
            UserDefaults.standard.synchronize()
        }
      /*  else if pickerView == dateFormatPicker {
                   dateLabel.text = dateArray[row]
            UserDefaults.standard.set(dateArray[row], forKey: "dateFormat")
            UserDefaults.standard.synchronize()
        }
        else if pickerView == timePicker {
                   timeLabel.text = timeArray[row]
            UserDefaults.standard.set(timeArray[row], forKey: "timeFormat")
            UserDefaults.standard.synchronize()
        }*/
        else if pickerView == depthPicker {
                    depthLabel.text = depthArray[row]
            UserDefaults.standard.set(depthArray[row], forKey: "depthFormat")
            UserDefaults.standard.synchronize()
        }
    }
    
    // MARK: - Image Picker Controller Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        profileImg.image = image
         picker.dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:true, completion: nil)
    }
    

}
