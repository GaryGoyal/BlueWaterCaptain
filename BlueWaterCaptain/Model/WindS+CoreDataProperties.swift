//
//  WindS+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 7/21/18.
//
//

import Foundation
import CoreData


extension WindS {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindS> {
        return NSFetchRequest<WindS>(entityName: "WindS")
    }

    @NSManaged public var windS: Int16
    @NSManaged public var forLocation: Location?
    @NSManaged public var verifiedBy: NSSet?

}

// MARK: Generated accessors for verifiedBy
extension WindS {

    @objc(addVerifiedByObject:)
    @NSManaged public func addToVerifiedBy(_ value: User)

    @objc(removeVerifiedByObject:)
    @NSManaged public func removeFromVerifiedBy(_ value: User)

    @objc(addVerifiedBy:)
    @NSManaged public func addToVerifiedBy(_ values: NSSet)

    @objc(removeVerifiedBy:)
    @NSManaged public func removeFromVerifiedBy(_ values: NSSet)

}
