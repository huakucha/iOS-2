//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by topsec on 17/1/10.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity");
    }

    @NSManaged public var uuid: String?
    @NSManaged public var tasktage: String?

}
