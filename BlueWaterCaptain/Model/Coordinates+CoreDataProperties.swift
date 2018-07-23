//
//  Coordinates+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 7/21/18.
//
//

import Foundation
import CoreData


extension Coordinates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coordinates> {
        return NSFetchRequest<Coordinates>(entityName: "Coordinates")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var forLocation: Location?
    @NSManaged public var verifiedBy: NSSet?

}

// MARK: Generated accessors for verifiedBy
extension Coordinates {

    @objc(addVerifiedByObject:)
    @NSManaged public func addToVerifiedBy(_ value: User)

    @objc(removeVerifiedByObject:)
    @NSManaged public func removeFromVerifiedBy(_ value: User)

    @objc(addVerifiedBy:)
    @NSManaged public func addToVerifiedBy(_ values: NSSet)

    @objc(removeVerifiedBy:)
    @NSManaged public func removeFromVerifiedBy(_ values: NSSet)

}
