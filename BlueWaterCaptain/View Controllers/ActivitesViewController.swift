//
//  ActivitesViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 7/14/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class ActivitesViewController: UIViewController {
    
    var isSideMenuOpened = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
