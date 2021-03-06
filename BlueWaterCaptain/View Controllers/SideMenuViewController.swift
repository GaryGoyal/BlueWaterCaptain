//
//  SideMenuViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/26/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import FBAnnotationClusteringSwift

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var username : UILabel!
    var menuItems : Array<String>!
    var loggedInUser : User!
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuItems = ["search","add","activities","help","settings"]
        profileImage.layer.cornerRadius = 50.0
               profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.predicate = NSPredicate(format: "userId == %@", (UserDefaults.standard.value(forKey: "LoggedInUser") as! String))
        request.returnsObjectsAsFaults = false
        do {
           let result = try context.fetch(request) as! Array<User>
            loggedInUser = result.first
            setUserDetails()
        } catch {}
        
         NotificationCenter.default.addObserver(self, selector: #selector(updateInfo(_:)), name: NSNotification.Name(rawValue: "updateUserInfo"), object: nil)
        
    }

    func updateInfo(_ notify : Notification) {
        setUserDetails()
    }
    
    func setUserDetails() {
      username.text = loggedInUser.username
        profileImage.image = UIImage(data: loggedInUser.profilePic! as Data)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = menuItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1) {
            performSegue(withIdentifier: "addNewLocSegue", sender: self)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewLocSegue" {
            let addNav = segue.destination as? UINavigationController
            let  addVC = addNav?.viewControllers.first as! AddEditViewController
            let annotation = FBAnnotation()
             annotation.coordinate = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "centerLat"), longitude: UserDefaults.standard.double(forKey: "centerLong"))
            annotation.title = "new"
            annotation.type = "new"
            addVC.newAnnotation = annotation
            addVC.isFromSideMenu = true
            addVC.isNewLocation = true
        }
    }
    

}
