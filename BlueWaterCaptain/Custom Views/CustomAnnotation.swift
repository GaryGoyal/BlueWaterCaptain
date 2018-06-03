//
//  CustomAnnotation.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/27/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var type : String?
    var location : Location?
      
        init(coordinate: CLLocationCoordinate2D) {
            self.coordinate = coordinate
        }
}
