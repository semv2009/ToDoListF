//
//  AppDelegate.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("TaskModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: self.managedObjectContext)
//        let newTask = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
//        newTask.setValue("Hello world", forKey: "name")
//        //newTask.setValue(NSDate(), forKey: "date")
       
        let importanceEntityDescription = NSEntityDescription.entityForName("Importance", inManagedObjectContext: self.managedObjectContext)
//        let newImportance = NSManagedObject(entity: importanceEntityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
//        newImportance.setValue("Low", forKey: "name")
//        newImportance.setValue(3, forKey: "order")
//        newImportance.setValue("Blue", forKey: "color")
//        do {
//            try newImportance.managedObjectContext?.save()
//        } catch {
//            let saveError = error as NSError
//            print(saveError)
//        }
//
//        let newTask2 = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
//        newTask2.setValue("New task day go", forKey: "name")
//        newTask2.setValue(NSDate(), forKey: "date")
//        //newTask2.setValue(NSSet(object: newImportance), forKey: "importances")
//        
//        do {
//            try newTask2.managedObjectContext?.save()
//        } catch {
//            let saveError = error as NSError
//            print(saveError)
//        }

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            print(result.count)
            for  i in 0...result.count-1 {
                let task = result[i] as! NSManagedObject
                print(task)
                let importance = task.valueForKey("importances") as! NSManagedObject
                print(importance.valueForKey("color"))
                //print("1 - \(task)")
//                
//                if let name = task.valueForKey("name"){
//                    print("\(name)")
//                }
            
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
        
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("Save all task")
        ManagerTask.sharedInstance().saveTasks()
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

