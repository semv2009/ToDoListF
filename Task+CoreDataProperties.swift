//
//  Task+CoreDataProperties.swift
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


extension Task: NSManagedObject, CoreDataModelable{

    @NSManaged var date: NSDate?
    @NSManaged var mark: NSNumber?
    @NSManaged var name: String?
    @NSManaged var importances: Importance?
    
    // MARK: - CoreDataModelable
    
    static let entityName = "Task"

}
