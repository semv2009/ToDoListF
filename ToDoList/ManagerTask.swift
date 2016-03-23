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
    
    func saveTaskNew(newTask:Task){
        var index = 0
        if tasks?.count > 0{
            while index < tasks!.count && newTask.orderMark > tasks![index].orderMark{
                index++
            }
            
            while index < tasks!.count && newTask.importance?.order ?? 4 > tasks![index].importance?.order ?? 4{
                index++
            }
            
            while index < tasks!.count && newTask.date?.timeIntervalSince1970 ?? 999999345345953453999999 > tasks![index].date?.timeIntervalSince1970 ?? 999999345345953453999999{
                print(newTask.date?.timeIntervalSince1970)
                index++
            }
            tasks?.append(newTask)
            var count = tasks!.count - 2
            while count > index{
                tasks![count+1] = tasks![count]
                count--
            }
            
            tasks![index] = newTask
        }else{
            tasks?.append(newTask)
        }
        print("Index = \(index)")
        
    }
    
    func getTask(index:Int) -> Task{
        return self.tasks![index]
    }
    
    func addTask(task:Task){
        saveTaskNew(task)
        //tasks?.append(task)
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