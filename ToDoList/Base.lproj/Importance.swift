//
//  Importance.swift
//  ToDoList
//
//  Created by developer on 01.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

@objc(Importance)
class Importance: NSManagedObject, CoreDataModelable{

    @NSManaged var color: String?
    @NSManaged var name: String?
    @NSManaged var priority: NSNumber?
    
    // MARK: - CoreDataModelable
    
    static let entityName = "Importance"

}
