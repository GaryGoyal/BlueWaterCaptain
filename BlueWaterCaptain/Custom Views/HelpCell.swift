//
//  HelpCell.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 7/22/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import MapKit

class HelpCell: UITableViewCell {
    
    @IBOutlet weak var headingLabel : UILabel!
    @IBOutlet weak var editLabel : UILabel?
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var arcView : ArcView?
    @IBOutlet weak var editButton : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
