//
//  WindN+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 8/8/18.
//
//

import Foundation
import CoreData


extension WindN {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindN> {
        return NSFetchRequest<WindN>(entityName: "WindN")
    }

    @NSManaged public var windN: Int16
    @NSManaged public var forLocation: Location?
    @NSManaged public var verifiedBy: NSSet?

}

// MARK: Generated accessors for verifiedBy
extension WindN {

    @objc(addVerifiedByObject:)
    @NSManaged public func addToVerifiedBy(_ value: User)

    @objc(removeVerifiedByObject:)
    @NSManaged public func removeFromVerifiedBy(_ value: User)

    @objc(addVerifiedBy:)
    @NSManaged public func addToVerifiedBy(_ values: NSSet)

    @objc(removeVerifiedBy:)
    @NSManaged public func removeFromVerifiedBy(_ values: NSSet)

}
