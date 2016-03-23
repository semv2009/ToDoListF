//
//  ManagerTask.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
class ManagerTask {
    static var manager: ManagerTask?
    
    var tasks : [Task]?
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private init(){
        if self.tasks == nil{
            //load from NSUserDefaults
            if let decoded  = defaults.objectForKey(Store.tasksKey) as? NSData{
                if let loadTasks = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? [Task]{
                    self.tasks = loadTasks
                }
            }else{
                self.tasks = [Task]()
            }
        }
    }
    
    static func sharedInstance() -> ManagerTask{
        if self.manager == nil{
            self.manager = ManagerTask()
        }
        return self.manager!
    }
    
    func saveTasks(){
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(self.tasks!)
        defaults.setObject(encodedData, forKey: Store.tasksKey)
        defaults.synchronize()
    }
    
    func addTask(task:Task){
        tasks?.append(task)
    }
    
    func removeTask(index:Int){
        tasks?.removeAtIndex(index)
    }
    
    func saveTask(task:Task,index:Int){
        tasks?.removeAtIndex(index)
        tasks?.insert(task, atIndex: index)
    }
    private struct Store{
        static let tasksKey = "TasksKey"
    }
    
}