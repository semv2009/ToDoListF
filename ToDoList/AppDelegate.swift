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
                dispatch_async(dispatch_get_main_queue()){
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
}

