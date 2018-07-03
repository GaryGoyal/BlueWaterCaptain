//
//  User+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 7/3/18.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userId: String?
    @NSManaged public var created: NSSet?
    @NSManaged public var added: NSSet?
    @NSManaged public var verified: Images?

}

// MARK: Generated accessors for created
extension User {

    @objc(addCreatedObject:)
    @NSManaged public func addToCreated(_ value: Location)

    @objc(removeCreatedObject:)
    @NSManaged public func removeFromCreated(_ value: Location)

    @objc(addCreated:)
    @NSManaged public func addToCreated(_ values: NSSet)

    @objc(removeCreated:)
    @NSManaged public func removeFromCreated(_ values: NSSet)

}

// MARK: Generated accessors for added
extension User {

    @objc(addAddedObject:)
    @NSManaged public func addToAdded(_ value: Images)

    @objc(removeAddedObject:)
    @NSManaged public func removeFromAdded(_ value: Images)

    @objc(addAdded:)
    @NSManaged public func addToAdded(_ values: NSSet)

    @objc(removeAdded:)
    @NSManaged public func removeFromAdded(_ values: NSSet)

}
