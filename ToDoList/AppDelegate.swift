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
    var coreDataStack: CoreDataStack?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = UINavigationController(rootViewController: LoadingViewController())
        CoreDataStack.constructSQLiteStack(withModelName: "TaskModel") { result in
            switch result {
            case .Success(let stack):
                self.coreDataStack = stack
                self.seedInitialData()
                
                let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC))
                dispatch_after(delay, dispatch_get_main_queue()) {
                    let mainViewController = TaskTableViewController(coreDataStack: stack)
                    self.window?.rootViewController = UINavigationController(rootViewController: mainViewController)
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
                let importances = try Importance.allInContext(moc)
                if importances.count == 0 {
                    let lowImportance = Importance(managedObjectContext: moc)
                    lowImportance.name = "Low"
                    lowImportance.priority = 2
                    lowImportance.color = "0 0 1 0.8"
                    
                    let normalImportance = Importance(managedObjectContext: moc)
                    normalImportance.name = "Normal"
                    normalImportance.priority = 1
                    normalImportance.color = "0 1 0 0.8"
                    
                    let hightlImportance = Importance(managedObjectContext: moc)
                    hightlImportance.name = "Hight"
                    hightlImportance.priority = 0
                    hightlImportance.color = "1 0 0 0.8"
                    
                    try moc.saveContextAndWait()
                }
            }
        } catch {
            print("Error creating inital data: \(error)")
        }
    }
}

