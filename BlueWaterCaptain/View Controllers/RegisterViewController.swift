//
//  RegisterViewController.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/30/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController , UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var waitIndicator: UIActivityIndicatorView!
    var textfieldHeight : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(RegisterViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func didTapView(){
        self.view.endEditing(true)
    }
    
    // MARK: - Button Actions
    
    @IBAction func signUpButtonClicked(sender: Any) {
        
        if(emailField.isFirstResponder) {
            emailField.resignFirstResponder()
        }
        if(passwordField.isFirstResponder) {
            passwordField.resignFirstResponder()
        }
        
        
        //signUpRequest()
    }
    
    // MARK: - Keyboard delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //  let textfieldBottom = CGPoint(x: textField.frame.origin.x, y: textField.frame.origin.y + textField.frame.size.height)
        
        //   print(textfieldBottom.y)
        
        let frame = self.view.convert(textField.frame, from:textField.superview)
        
        // let fieldPoint =  textField.convert(textfieldBottom, to: self.view)
        
        let fieldPoint = frame.origin.y + textField.frame.size.height
        
        print(fieldPoint)
        
        //  textfieldHeight = fieldPoint.y
        
        textfieldHeight = fieldPoint
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            let shiftDistance = endFrame?.size.height
            
            if ((endFrame?.origin.y)! < textfieldHeight + 64) {
                
                // shiftDistance = Double(textfieldHeight - (endFrame?.origin.y)!)
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: {
                                var frame = self.view.frame
                                frame.origin.y = -(CGFloat)(shiftDistance!)
                                self.view.frame = frame
                },
                               completion: nil)
            }
        }
    }
    
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            var frame = self.view.frame
                            frame.origin.y = 0
                            self.view.frame = frame
            },
                           completion: nil)
        }
    }
}
