//
//  ManagerTask.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
class TaskManager {
    static var manager: TaskManager?
    
    var tasks : [Task]?
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    private init(){
//        if let _ = self.tasks {} else{
//            if let decoded  = defaults.objectForKey(Store.tasksKey) as? NSData, loadTasks = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? [Task]{
//                self.tasks = loadTasks
//            }else{
//                self.tasks = [Task]()
//            }
//        }
    }
    
//    static func sharedInstance() -> TaskManager{
//        
//    }
    
     static var sharedInstance: TaskManager{
        if let _ = self.manager {} else{
            self.manager = TaskManager()
        }
        return self.manager!
    }
    
    func saveTasks(){
//        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(self.tasks!)
//        defaults.setObject(encodedData, forKey: Store.tasksKey)
//        defaults.synchronize()
    }
    
    func saveTask(task:Task){}
//        var index = 0
//        if tasks?.count > 0{
//            while index < tasks!.count && task.orderMark > tasks![index].orderMark{
//                index += 1
//            }
//            
//            while index < tasks!.count && task.orderImportance > tasks![index].orderImportance && task.orderMark == tasks![index].orderMark{
//                index += 1
//            }
//            
//            while index < tasks!.count && task.date?.timeIntervalSince1970 ?? Constants.maxDateInt > tasks![index].date?.timeIntervalSince1970 ?? Constants.maxDateInt && task.orderImportance == tasks![index].orderImportance && task.orderMark == tasks![index].orderMark{
//                index += 1
//            }
//            
//            tasks?.append(task)
//            var count = tasks!.count - 2
//            while count >= index{
//                tasks![count+1] = tasks![count]
//                count -= 1
//            }
//            
//            tasks![index] = task
//        }else{
//            tasks?.append(task)
//        }
//    }
//    
//    func getTask(index:Int) -> Task{
//        return tasks![index]
//    }
//    
//    func addTask(task:Task){
//        saveTask(task)
//    }
//    
//    func removeTask(index:Int){
//        tasks?.removeAtIndex(index)
//    }
//    
//    func saveTask(task:Task,index:Int){
//        tasks?.removeAtIndex(index)
//        saveTask(task)
//    }
//    
//    private struct Store{
//        static let tasksKey = "TasksKey"
//    }
    
}