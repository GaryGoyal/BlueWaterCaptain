//
//  SettingsViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/27/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
     @IBOutlet weak var nameLabel: UILabel!
     @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var dateLabel : UILabel!
     @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet weak var depthLabel: UILabel!
     @IBOutlet weak var profileImg: UIImageView!
     @IBOutlet weak var locationSwitch: UISwitch!
     @IBOutlet weak var notificationSwitch: UISwitch!
     @IBOutlet weak var nameEditButton: UIButton!
     @IBOutlet weak var imgEditButton: UIButton!
     @IBOutlet weak var depthEditButton: UIButton!
     @IBOutlet weak var timeEditButton: UIButton!
     @IBOutlet weak var dateEditButton: UIButton!
     @IBOutlet weak var degreeEditButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    @IBAction func openSideMenu(_ sender : Any) {
        
    }

    @IBAction func nameEditButtonTapped(_ sender : Any) {
        
    }

    @IBAction func degreeEditButtonTapped(_ sender : Any) {
        
    }

    @IBAction func depthEditButtonTapped(_ sender : Any) {
        
    }

    @IBAction func dateEditButtonTapped(_ sender : Any) {
        
    }

    @IBAction func timeEditButtonTapped(_ sender : Any) {
        
    }

    @IBAction func imgEditButtonTapped(_ sender : Any) {
        
    }
    
    @IBAction func locationSwitchPressed(_ sender : Any) {
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
    
    @IBAction func notificationSwitchPressed(_ sender : Any) {
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

}
