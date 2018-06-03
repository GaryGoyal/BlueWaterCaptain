//
//  LoginViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/30/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Textfield delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Button Actions
    
    @IBAction func loginButtonClicked(sender: Any) {
        
        if(userField.text == "") {
         self.shakeForIncompleteLoginCredentials(emptyField: userField)
         return
         }
         if(passwordField.text == "") {
         self.shakeForIncompleteLoginCredentials(emptyField: passwordField)
         return
         }
         if(userField.isFirstResponder) {
         userField.resignFirstResponder()
         }
         if(passwordField.isFirstResponder) {
         passwordField.resignFirstResponder()
         }
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    
    @IBAction func forgotPasswordButtonClicked(sender: Any) {
       // resetPasswordRequest()
    }
    
    
    // MARK: - Shake animation
    
    func shakeForIncompleteLoginCredentials(emptyField: UITextField) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isAdditive = true
        emptyField.layer.add(animation, forKey: "shake")
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        /* if segue.identifier == LOGIN_SEGUE {
         let imageVC = (segue.destination as? ScheduleImageViewController)
         imageVC?.userDetails = loggedInUser
         }*/
    }
    
    // MARK: - Web Service Calls
    
  
}
