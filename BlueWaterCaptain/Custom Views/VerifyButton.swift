//
//  VerifyButton.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 6/26/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class VerifyButton: UIButton {

    var isVerified : Bool = false  {
        willSet(newValue)
        {
            if(newValue) {
                self.setBackgroundImage(UIImage(named: "verify_grey"), for: .normal)
            }
            else {
               self.setBackgroundImage(UIImage(named: "verify"), for: .normal)
            }
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
       super.draw(rect)
//       self.setBackgroundImage(UIImage(named: "verify"), for: .normal)
//        self.setBackgroundImage(UIImage(named: "verify_grey"), for: .selected)
    }
 
    func set() {
        
    }

}
