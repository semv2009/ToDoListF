//
//  Importance+CoreDataProperties.swift
//  
//
//  Created by developer on 01.04.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import BNRCoreDataStack

extension Importance: NSManagedObject, CoreDataModelable{

    @NSManaged var color: String?
    @NSManaged var name: String?
    @NSManaged var priority: NSNumber?
    
    // MARK: - CoreDataModelable
    
    static let entityName = "Importance"

}
