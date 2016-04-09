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
    @NSManaged var date: NSDate
    @NSManaged var mark: Bool
    @NSManaged var name: String
    @NSManaged var priority: Int
    
    // MARK: - CoreDataModelable
    
    static let entityName = "Task"
}

struct Importance{
    let name: String
    let color: String
    let priority: Int
}

struct Importances{
    static let Low = Importance(name: "Low", color: "0 0 1 0.8", priority: 0)
    static let Normal = Importance(name: "Normal", color: "0 1 0 0.8", priority: 1)
    static let Hight = Importance(name: "Hight", color: "1 0 0 0.8", priority: 2)
    
    static func getImportance(priority priority: Int) -> Importance{
        switch priority {
            case 0: return Low
            case 1: return Normal
            case 2: return Hight
            default: return Low
        }
    }
    
    static let allImportance: [Importance] = [Low, Normal, Hight]
}
