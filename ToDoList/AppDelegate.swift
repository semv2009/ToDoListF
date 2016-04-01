//
//  AppDelegate.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData
import BNRCoreDataStack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var coreDataStack: CoreDataStack?
    private lazy var loadingVC: UIViewController = {
        return self.mainStoryboard.instantiateViewControllerWithIdentifier("LoadingVC")
    }()
    private lazy var myCoreDataVC: TaskTableViewController = {
        return self.mainStoryboard.instantiateViewControllerWithIdentifier("CoreDataVC")
            as! TaskTableViewController
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("start")
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = loadingVC
        
        CoreDataStack.constructSQLiteStack(withModelName: "TaskModel") { result in
            switch result {
            case .Success(let stack):
                self.coreDataStack = stack
                self.seedInitialData()
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
                dispatch_after(delay, dispatch_get_main_queue()) {
                    self.myCoreDataVC.stack = stack
                    self.window?.rootViewController = UINavigationController(rootViewController: self.myCoreDataVC)
                }


            case .Failure(let error):
                assertionFailure("\(error)")
            }
        }
        
        window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        guard let stack = coreDataStack else {
            assertionFailure("Stack was not setup first")
            return
        }
        do{
            try stack.mainQueueContext.save()
        } catch{
            print(error)
        }
        
    }
    
    private func seedInitialData() {
        guard let stack = coreDataStack else {
            assertionFailure("Stack was not setup first")
            return
        }
        let moc = stack.newBackgroundWorkerMOC()
        do {
            try moc.performAndWaitOrThrow {
                try Task.removeAllInContext(moc)
                var importances = try Importance.allInContext(moc)
                print(importances)
                moc.deleteObject(importances[importances.count-1])
                importances.removeLast()
                
                let im3 = Importance(managedObjectContext: moc)
                im3.name = "Hight"
                im3.priority = 0
                im3.color = "1 0 0 0.8"
                
                importances.append(im3)
                
                for i in 0...importances.count-1{
                    let task = Task(managedObjectContext: moc)
                    task.name = "Hello world"
                    task.date = NSDate()
                    task.mark = false
                    task.importances = importances[i]
                }
                
                try moc.saveContextAndWait()
            }
        } catch {
            print("Error creating inital data: \(error)")
        }
//
//        let moc = stack.newBackgroundWorkerMOC()
//        do {
//            try moc.performAndWaitOrThrow {
//                let im1 = Importance(managedObjectContext: moc)
//                im1.name = "Low"
//                im1.priority = 2
//                im1.color = "0 0 1 0.8"
//                
//                let im2 = Importance(managedObjectContext: moc)
//                im2.name = "Normal"
//                im2.priority = 1
//                im2.color = "0 1 0 0.8"
//                
//                let im3 = Importance(managedObjectContext: moc)
//                im3.name = "Hight"
//                im3.priority = 0
//                im3.color = "0 1 0 0.8"
//                
//                try moc.saveContextAndWait()
//            }
//        } catch {
//            print("Error creating inital data: \(error)")
//        }
    }
}

