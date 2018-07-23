//
//  FilterViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 6/2/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController,ArcViewDelegate {
    
    
    @IBOutlet weak var anchorageSwitch: UISwitch!
     @IBOutlet weak var bouySwitch: UISwitch!
     @IBOutlet weak var marinaSwitch: UISwitch!
     @IBOutlet weak var depthSlider: UISlider!
     @IBOutlet weak var depthValue: UILabel!
    @IBOutlet weak var arcView : ArcView!
     @IBOutlet weak var filterLabel: UILabel!
    var dirArray = ["SE","S","SW","W","NW","N","NE","E"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateMesg()
    
        let types  = UserDefaults.standard.object(forKey: "types") as! [String]
        
        if types.contains("Anchorage") {
            anchorageSwitch.isOn = true
        }
        else {
            anchorageSwitch.isOn = false
        }
        
        if types.contains("Buoy") {
            bouySwitch.isOn = true
        }
        else {
            bouySwitch.isOn = false
        }
        
        if types.contains("Marina") {
            marinaSwitch.isOn = true
        }
        else {
            marinaSwitch.isOn = false
        }
        
        depthSlider.value = Float(UserDefaults.standard.double(forKey: "depthValue"))
        depthValue.text = ">=" + String(format: "%.1f", UserDefaults.standard.double(forKey: "depthValue")) + " m"
        
        arcView.delegate = self
        arcView.isFilter = true
        arcView.createArcWithWidth(arcWidth: 15.0, andWindArray:        (UserDefaults.standard.value(forKey: "windDirFilter") as! Array<Int16>))
        
    }
    
    func updateWindDirections(_ windArray: Array<Int16>) {
        UserDefaults.standard.set(windArray, forKey: "windDirFilter")
        updateMesg()
    }
    
    
    func updateMesg() {
        var mesg = "Only locations will be shown, that are marked protected with wind from"
        let arr = (UserDefaults.standard.value(forKey: "windDirFilter") as! Array<Int16>)
        for i in 0..<arr.count {
            if(arr[i] == 1) {
                mesg = mesg + " " + dirArray[i] + ","
            }
        }
        if(!(arr.contains(1))) {
            mesg = "Locations are not filtered by wind direction"
        }
        filterLabel.text = mesg
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     @IBAction func cancelButtonPressed(_ sender : Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

     @IBAction func anchorageSwitchPressed(_ sender : Any) {
        
        if anchorageSwitch.isOn {
            var types = UserDefaults.standard.object(forKey: "types") as! [String]
            types.append("Anchorage")
            UserDefaults.standard.set(types, forKey: "types")
            UserDefaults.standard.synchronize()
        }
        else {
            var types = UserDefaults.standard.object(forKey: "types") as! [String]
           types = types.filter { $0 != "Anchorage" }
            UserDefaults.standard.set(types, forKey: "types")
            UserDefaults.standard.synchronize()
            
        }
    }
    

    @IBAction func buoySwitchPressed(_ sender : Any) {
        
        if bouySwitch.isOn {
            var types = UserDefaults.standard.object(forKey: "types") as! [String]
            types.append("Buoy")
            UserDefaults.standard.set(types, forKey: "types")
            UserDefaults.standard.synchronize()
        }
        else {
            var types = UserDefaults.standard.object(forKey: "types") as! [String]
            types = types.filter { $0 != "Buoy" }
            UserDefaults.standard.set(types, forKey: "types")
            UserDefaults.standard.synchronize()
            
        }
    }
    
    @IBAction func marinaSwitchPressed(_ sender : Any) {
        
        if marinaSwitch.isOn {
            var types = UserDefaults.standard.object(forKey: "types") as! [String]
            types.append("Marina")
            UserDefaults.standard.set(types, forKey: "types")
            UserDefaults.standard.synchronize()
        }
        else {
            var types = UserDefaults.standard.object(forKey: "types") as! [String]
            types = types.filter { $0 != "Marina" }
            UserDefaults.standard.set(types, forKey: "types")
            UserDefaults.standard.synchronize()
            
        }
    }
    
    @IBAction func depthSliderValueChanged(_ sender : Any) {

        let roundedValue = round((sender as! UISlider).value / 0.5) * 0.5
        (sender as! UISlider).value = roundedValue
         depthValue.text = ">= " + String(format: "%.1f", depthSlider.value) + " m"
        UserDefaults.standard.set(roundedValue, forKey: "depthValue")
        UserDefaults.standard.synchronize()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0) {
            return 290
        }
        else {
            return 60
        }
        
    }

 /*   override func numberOfSections(in tableView: UITableView) -> Int {
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
