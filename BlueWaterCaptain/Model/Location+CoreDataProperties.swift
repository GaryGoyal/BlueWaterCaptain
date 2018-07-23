//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 7/22/18.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var distance: Double
    @NSManaged public var addedBy: User?
    @NSManaged public var city: City?
    @NSManaged public var coordinates: Coordinates?
    @NSManaged public var depth: Depth?
    @NSManaged public var images: NSSet?
    @NSManaged public var island: Island?
    @NSManaged public var locdescription: Description?
    @NSManaged public var name: Name?
    @NSManaged public var type: Type?
    @NSManaged public var verifiedBy: NSSet?
    @NSManaged public var versions: NSSet?
    @NSManaged public var windE: WindE?
    @NSManaged public var windN: WindN?
    @NSManaged public var windNE: WindNE?
    @NSManaged public var windNW: WindNW?
    @NSManaged public var windS: WindS?
    @NSManaged public var windSE: WindSE?
    @NSManaged public var windSW: WindSW?
    @NSManaged public var windW: WindW?

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

// MARK: Generated accessors for verifiedBy
extension Location {

    @objc(addVerifiedByObject:)
    @NSManaged public func addToVerifiedBy(_ value: User)

    @objc(removeVerifiedByObject:)
    @NSManaged public func removeFromVerifiedBy(_ value: User)

    @objc(addVerifiedBy:)
    @NSManaged public func addToVerifiedBy(_ values: NSSet)

    @objc(removeVerifiedBy:)
    @NSManaged public func removeFromVerifiedBy(_ values: NSSet)

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
