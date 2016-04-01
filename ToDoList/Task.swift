//
//  Task.swift
//  ToDoList
//
//  Created by developer on 01.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

import Foundation
class Task: NSManagedObject, CoreDataModelable{
    @NSManaged var date: NSDate?
    @NSManaged var mark: Bool
    @NSManaged var name: String
    @NSManaged var importances: Importance?
    
    // MARK: - CoreDataModelable
    
    static let entityName = "Task"
}

