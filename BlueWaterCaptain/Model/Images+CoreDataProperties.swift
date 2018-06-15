//
//  Images+CoreDataProperties.swift
//  BlueWaterCaptain
//
//  Created by Garima Aggarwal on 6/12/18.
//  Copyright © 2018 Garima Aggarwal. All rights reserved.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var verification: Int16
    @NSManaged public var forLocation: Location?

}
