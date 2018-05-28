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
        var image: UIImage?
    var type : String?
      
        init(coordinate: CLLocationCoordinate2D) {
            self.coordinate = coordinate
        }
}
