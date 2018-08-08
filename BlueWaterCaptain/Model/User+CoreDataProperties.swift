//
//  User+CoreDataProperties.swift
//  
//
//  Created by Garima Aggarwal on 8/8/18.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var profilePic: NSData?
    @NSManaged public var userId: String?
    @NSManaged public var username: String?
    @NSManaged public var addedLoc: NSSet?
    @NSManaged public var verifiedCity: NSSet?
    @NSManaged public var verifiedCoordinates: NSSet?
    @NSManaged public var verifiedDepth: NSSet?
    @NSManaged public var verifiedDesc: NSSet?
    @NSManaged public var verifiedImage: NSSet?
    @NSManaged public var verifiedIsland: NSSet?
    @NSManaged public var verifiedLocation: NSSet?
    @NSManaged public var verifiedName: NSSet?
    @NSManaged public var verifiedType: NSSet?
    @NSManaged public var verifiedWindE: NSSet?
    @NSManaged public var verifiedWindN: NSSet?
    @NSManaged public var verifiedWindNE: NSSet?
    @NSManaged public var verifiedWindNW: NSSet?
    @NSManaged public var verifiedWindS: NSSet?
    @NSManaged public var verifiedWindSE: NSSet?
    @NSManaged public var verifiedWindSW: NSSet?
    @NSManaged public var verifiedWindW: NSSet?

}

// MARK: Generated accessors for addedLoc
extension User {

    @objc(addAddedLocObject:)
    @NSManaged public func addToAddedLoc(_ value: Location)

    @objc(removeAddedLocObject:)
    @NSManaged public func removeFromAddedLoc(_ value: Location)

    @objc(addAddedLoc:)
    @NSManaged public func addToAddedLoc(_ values: NSSet)

    @objc(removeAddedLoc:)
    @NSManaged public func removeFromAddedLoc(_ values: NSSet)

}

// MARK: Generated accessors for verifiedCity
extension User {

    @objc(addVerifiedCityObject:)
    @NSManaged public func addToVerifiedCity(_ value: City)

    @objc(removeVerifiedCityObject:)
    @NSManaged public func removeFromVerifiedCity(_ value: City)

    @objc(addVerifiedCity:)
    @NSManaged public func addToVerifiedCity(_ values: NSSet)

    @objc(removeVerifiedCity:)
    @NSManaged public func removeFromVerifiedCity(_ values: NSSet)

}

// MARK: Generated accessors for verifiedCoordinates
extension User {

    @objc(addVerifiedCoordinatesObject:)
    @NSManaged public func addToVerifiedCoordinates(_ value: Coordinates)

    @objc(removeVerifiedCoordinatesObject:)
    @NSManaged public func removeFromVerifiedCoordinates(_ value: Coordinates)

    @objc(addVerifiedCoordinates:)
    @NSManaged public func addToVerifiedCoordinates(_ values: NSSet)

    @objc(removeVerifiedCoordinates:)
    @NSManaged public func removeFromVerifiedCoordinates(_ values: NSSet)

}

// MARK: Generated accessors for verifiedDepth
extension User {

    @objc(addVerifiedDepthObject:)
    @NSManaged public func addToVerifiedDepth(_ value: Depth)

    @objc(removeVerifiedDepthObject:)
    @NSManaged public func removeFromVerifiedDepth(_ value: Depth)

    @objc(addVerifiedDepth:)
    @NSManaged public func addToVerifiedDepth(_ values: NSSet)

    @objc(removeVerifiedDepth:)
    @NSManaged public func removeFromVerifiedDepth(_ values: NSSet)

}

// MARK: Generated accessors for verifiedDesc
extension User {

    @objc(addVerifiedDescObject:)
    @NSManaged public func addToVerifiedDesc(_ value: Description)

    @objc(removeVerifiedDescObject:)
    @NSManaged public func removeFromVerifiedDesc(_ value: Description)

    @objc(addVerifiedDesc:)
    @NSManaged public func addToVerifiedDesc(_ values: NSSet)

    @objc(removeVerifiedDesc:)
    @NSManaged public func removeFromVerifiedDesc(_ values: NSSet)

}

// MARK: Generated accessors for verifiedImage
extension User {

    @objc(addVerifiedImageObject:)
    @NSManaged public func addToVerifiedImage(_ value: Images)

    @objc(removeVerifiedImageObject:)
    @NSManaged public func removeFromVerifiedImage(_ value: Images)

    @objc(addVerifiedImage:)
    @NSManaged public func addToVerifiedImage(_ values: NSSet)

    @objc(removeVerifiedImage:)
    @NSManaged public func removeFromVerifiedImage(_ values: NSSet)

}

// MARK: Generated accessors for verifiedIsland
extension User {

    @objc(addVerifiedIslandObject:)
    @NSManaged public func addToVerifiedIsland(_ value: Island)

    @objc(removeVerifiedIslandObject:)
    @NSManaged public func removeFromVerifiedIsland(_ value: Island)

    @objc(addVerifiedIsland:)
    @NSManaged public func addToVerifiedIsland(_ values: NSSet)

    @objc(removeVerifiedIsland:)
    @NSManaged public func removeFromVerifiedIsland(_ values: NSSet)

}

// MARK: Generated accessors for verifiedLocation
extension User {

    @objc(addVerifiedLocationObject:)
    @NSManaged public func addToVerifiedLocation(_ value: Location)

    @objc(removeVerifiedLocationObject:)
    @NSManaged public func removeFromVerifiedLocation(_ value: Location)

    @objc(addVerifiedLocation:)
    @NSManaged public func addToVerifiedLocation(_ values: NSSet)

    @objc(removeVerifiedLocation:)
    @NSManaged public func removeFromVerifiedLocation(_ values: NSSet)

}

// MARK: Generated accessors for verifiedName
extension User {

    @objc(addVerifiedNameObject:)
    @NSManaged public func addToVerifiedName(_ value: Name)

    @objc(removeVerifiedNameObject:)
    @NSManaged public func removeFromVerifiedName(_ value: Name)

    @objc(addVerifiedName:)
    @NSManaged public func addToVerifiedName(_ values: NSSet)

    @objc(removeVerifiedName:)
    @NSManaged public func removeFromVerifiedName(_ values: NSSet)

}

// MARK: Generated accessors for verifiedType
extension User {

    @objc(addVerifiedTypeObject:)
    @NSManaged public func addToVerifiedType(_ value: Type)

    @objc(removeVerifiedTypeObject:)
    @NSManaged public func removeFromVerifiedType(_ value: Type)

    @objc(addVerifiedType:)
    @NSManaged public func addToVerifiedType(_ values: NSSet)

    @objc(removeVerifiedType:)
    @NSManaged public func removeFromVerifiedType(_ values: NSSet)

}

// MARK: Generated accessors for verifiedWindE
extension User {

    @objc(addVerifiedWindEObject:)
    @NSManaged public func addToVerifiedWindE(_ value: WindE)

    @objc(removeVerifiedWindEObject:)
    @NSManaged public func removeFromVerifiedWindE(_ value: WindE)

    @objc(addVerifiedWindE:)
    @NSManaged public func addToVerifiedWindE(_ values: NSSet)

    @objc(removeVerifiedWindE:)
    @NSManaged public func removeFromVerifiedWindE(_ values: NSSet)

}

// MARK: Generated accessors for verifiedWindN
extension User {

    @objc(addVerifiedWindNObject:)
    @NSManaged public func addToVerifiedWindN(_ value: WindN)

    @objc(removeVerifiedWindNObject:)
    @NSManaged public func removeFromVerifiedWindN(_ value: WindN)

    @objc(addVerifiedWindN:)
    @NSManaged public func addToVerifiedWindN(_ values: NSSet)

    @objc(removeVerifiedWindN:)
    @NSManaged public func removeFromVerifiedWindN(_ values: NSSet)

}

// MARK: Generated accessors for verifiedWindNE
extension User {

    @objc(addVerifiedWindNEObject:)
    @NSManaged public func addToVerifiedWindNE(_ value: WindNE)

    @objc(removeVerifiedWindNEObject:)
    @NSManaged public func removeFromVerifiedWindNE(_ value: WindNE)

    @objc(addVerifiedWindNE:)
    @NSManaged public func addToVerifiedWindNE(_ values: NSSet)

    @objc(removeVerifiedWindNE:)
    @NSManaged public func removeFromVerifiedWindNE(_ values: NSSet)

}

// MARK: Generated accessors for verifiedWindNW
extension User {

    @objc(addVerifiedWindNWObject:)
    @NSManaged public func addToVerifiedWindNW(_ value: WindNW)

    @objc(removeVerifiedWindNWObject:)
    @NSManaged public func removeFromVerifiedWindNW(_ value: WindNW)

    @objc(addVerifiedWindNW:)
    @NSManaged public func addToVerifiedWindNW(_ values: NSSet)

    @objc(removeVerifiedWindNW:)
    @NSManaged public func removeFromVerifiedWindNW(_ values: NSSet)

}

// MARK: Generated accessors for verifiedWindS
extension User {

    @objc(addVerifiedWindSObject:)
    @NSManaged public func addToVerifiedWindS(_ value: WindS)

    @objc(removeVerifiedWindSObject:)
    @NSManaged public func removeFromVerifiedWindS(_ value: WindS)

    @objc(addVerifiedWindS:)
    @NSManaged public func addToVerifiedWindS(_ values: NSSet)

    @objc(removeVerifiedWindS:)
    @NSManaged public func removeFromVerifiedWindS(_ values: NSSet)

}

// MARK: Generated accessors for verifiedWindSE
extension User {

    @objc(addVerifiedWindSEObject:)
    @NSManaged public func addToVerifiedWindSE(_ value: WindSE)

    @objc(removeVerifiedWindSEObject:)
    @NSManaged public func removeFromVerifiedWindSE(_ value: WindSE)

    @objc(addVerifiedWindSE:)
    @NSManaged public func addToVerifiedWindSE(_ values: NSSet)

    @objc(removeVerifiedWindSE:)
    @NSManaged public func removeFromVerifiedWindSE(_ values: NSSet)

}

// MARK: Generated accessors for verifiedWindSW
extension User {

    @objc(addVerifiedWindSWObject:)
    @NSManaged public func addToVerifiedWindSW(_ value: WindSW)

    @objc(removeVerifiedWindSWObject:)
    @NSManaged public func removeFromVerifiedWindSW(_ value: WindSW)

    @objc(addVerifiedWindSW:)
    @NSManaged public func addToVerifiedWindSW(_ values: NSSet)

    @objc(removeVerifiedWindSW:)
    @NSManaged public func removeFromVerifiedWindSW(_ values: NSSet)

}

// MARK: Generated accessors for verifiedWindW
extension User {

    @objc(addVerifiedWindWObject:)
    @NSManaged public func addToVerifiedWindW(_ value: WindW)

    @objc(removeVerifiedWindWObject:)
    @NSManaged public func removeFromVerifiedWindW(_ value: WindW)

    @objc(addVerifiedWindW:)
    @NSManaged public func addToVerifiedWindW(_ values: NSSet)

    @objc(removeVerifiedWindW:)
    @NSManaged public func removeFromVerifiedWindW(_ values: NSSet)

}
