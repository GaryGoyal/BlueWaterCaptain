//
//  Versioning+CoreDataProperties.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 6/4/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//
//

import Foundation
import CoreData


extension Versioning {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Versioning> {
        return NSFetchRequest<Versioning>(entityName: "Versioning")
    }

    @NSManaged public var verification: Int16
    @NSManaged public var attributeId: String?
    @NSManaged public var previousValue: String?
    @NSManaged public var timeOfChange: NSDate?
    @NSManaged public var forLocation: Location?

}
