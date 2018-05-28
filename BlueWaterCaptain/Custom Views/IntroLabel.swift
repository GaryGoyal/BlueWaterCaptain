//
//  IntroLabel.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/24/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class IntroLabel: UILabel {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.shadowOffset = CGSize(width : 1, height : 5)
       self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 0.3

    }
 

}
