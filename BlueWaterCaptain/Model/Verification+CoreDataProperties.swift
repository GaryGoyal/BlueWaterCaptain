//
//  Verification+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 7/3/18.
//
//

import Foundation
import CoreData


extension Verification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Verification> {
        return NSFetchRequest<Verification>(entityName: "Verification")
    }

    @NSManaged public var city: Int16
    @NSManaged public var coordinates: Int16
    @NSManaged public var depth: Int16
    @NSManaged public var island: Int16
    @NSManaged public var locDescription: Int16
    @NSManaged public var name: Int16
    @NSManaged public var type: Int16
    @NSManaged public var windE: Int16
    @NSManaged public var windN: Int16
    @NSManaged public var windNE: Int16
    @NSManaged public var windNW: Int16
    @NSManaged public var windS: Int16
    @NSManaged public var windSE: Int16
    @NSManaged public var windW: Int16
    @NSManaged public var windSW: Int16
    @NSManaged public var forLocation: Location?

}
