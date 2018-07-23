//
//  Depth+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 7/21/18.
//
//

import Foundation
import CoreData


extension Depth {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Depth> {
        return NSFetchRequest<Depth>(entityName: "Depth")
    }

    @NSManaged public var depth: Double
    @NSManaged public var forLocation: Location?
    @NSManaged public var verifiedBy: NSSet?

}

// MARK: Generated accessors for verifiedBy
extension Depth {

    @objc(addVerifiedByObject:)
    @NSManaged public func addToVerifiedBy(_ value: User)

    @objc(removeVerifiedByObject:)
    @NSManaged public func removeFromVerifiedBy(_ value: User)

    @objc(addVerifiedBy:)
    @NSManaged public func addToVerifiedBy(_ values: NSSet)

    @objc(removeVerifiedBy:)
    @NSManaged public func removeFromVerifiedBy(_ values: NSSet)

}
