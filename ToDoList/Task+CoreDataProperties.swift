//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by developer on 01.04.16.
//  Copyright © 2016 developer. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Task {

    @NSManaged var date: NSTimeInterval
    @NSManaged var mark: Bool
    @NSManaged var name: String?
    @NSManaged var importances: Importance?

}
