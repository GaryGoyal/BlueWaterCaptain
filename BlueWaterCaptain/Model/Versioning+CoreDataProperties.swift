//
//  Versioning+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 8/8/18.
//
//

import Foundation
import CoreData


extension Versioning {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Versioning> {
        return NSFetchRequest<Versioning>(entityName: "Versioning")
    }

    @NSManaged public var attributeId: String?
    @NSManaged public var previousValue: String?
    @NSManaged public var timeOfChange: NSDate?
    @NSManaged public var verification: Int16
    @NSManaged public var forLocation: Location?

}
