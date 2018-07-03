//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 7/3/18.
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
    @NSManaged public var windE: Int16
    @NSManaged public var windN: Int16
    @NSManaged public var windNE: Int16
    @NSManaged public var windNW: Int16
    @NSManaged public var windS: Int16
    @NSManaged public var windSE: Int16
    @NSManaged public var windSW: Int16
    @NSManaged public var windW: Int16
    @NSManaged public var images: NSSet?
    @NSManaged public var verifications: Verification?
    @NSManaged public var versions: NSSet?
    @NSManaged public var createdBy: User?

}

// MARK: Generated accessors for images
extension Location {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Images)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Images)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

// MARK: Generated accessors for versions
extension Location {

    @objc(addVersionsObject:)
    @NSManaged public func addToVersions(_ value: Versioning)

    @objc(removeVersionsObject:)
    @NSManaged public func removeFromVersions(_ value: Versioning)

    @objc(addVersions:)
    @NSManaged public func addToVersions(_ values: NSSet)

    @objc(removeVersions:)
    @NSManaged public func removeFromVersions(_ values: NSSet)

}
