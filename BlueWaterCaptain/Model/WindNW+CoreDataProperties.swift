//
//  WindNW+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 7/21/18.
//
//

import Foundation
import CoreData


extension WindNW {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindNW> {
        return NSFetchRequest<WindNW>(entityName: "WindNW")
    }

    @NSManaged public var windNW: Int16
    @NSManaged public var forLocation: Location?
    @NSManaged public var verifiedBy: NSSet?

}

// MARK: Generated accessors for verifiedBy
extension WindNW {

    @objc(addVerifiedByObject:)
    @NSManaged public func addToVerifiedBy(_ value: User)

    @objc(removeVerifiedByObject:)
    @NSManaged public func removeFromVerifiedBy(_ value: User)

    @objc(addVerifiedBy:)
    @NSManaged public func addToVerifiedBy(_ values: NSSet)

    @objc(removeVerifiedBy:)
    @NSManaged public func removeFromVerifiedBy(_ values: NSSet)

}
