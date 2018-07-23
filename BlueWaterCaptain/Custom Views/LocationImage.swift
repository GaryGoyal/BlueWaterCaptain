//
//  LocationImage.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 6/18/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit

class LocationImage: UIView {
    
    @IBOutlet weak var duplicateLabel : UILabel!
    @IBOutlet weak var verifyLabel : UILabel!
    @IBOutlet weak var photoView : UIImageView!
    @IBOutlet weak var verifyButton : VerifyButton!
    var locImage : Images!
    
    class func instanceFromNibWithFrame(frame : CGRect) -> UIView {
        
        let view = UINib(nibName: "LocationImage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        print(frame.size.width)
        view.frame = frame
        return view
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
