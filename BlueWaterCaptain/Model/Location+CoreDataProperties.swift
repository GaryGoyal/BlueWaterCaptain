//
//  Location+CoreDataProperties.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 5/28/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var depth: Double
    @NSManaged public var island: String?
    @NSManaged public var latitude: Double
    @NSManaged public var locDescription: String?
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var windE: Bool
    @NSManaged public var windN: Bool
    @NSManaged public var windNE: Bool
    @NSManaged public var windNW: Bool
    @NSManaged public var windS: Bool
    @NSManaged public var windSE: Bool
    @NSManaged public var windSW: Bool
    @NSManaged public var windW: Bool

}
