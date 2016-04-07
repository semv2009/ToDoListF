//
//  TaskTableViewController.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData
import BNRCoreDataStack

class TaskTableViewController: UITableViewController{

    var stack: CoreDataStack!
    
    private lazy var fetchedResultsController: FetchedResultsController<Task> = {
        let fetchRequest = NSFetchRequest(entityName: Task.entityName)
        let solvedSortDescriptor = NSSortDescriptor(key: "mark", ascending: true)
        let prioritySortDescriptor = NSSortDescriptor(key: "importances.priority", ascending: true)
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [solvedSortDescriptor, prioritySortDescriptor, dateSortDescriptor]
        let frc = FetchedResultsController<Task>(fetchRequest: fetchRequest, managedObjectContext: self.stack.mainQueueContext, sectionNameKeyPath: nil)
        frc.setDelegate(self.frcDelegate)
        return frc
    }()
    
    private lazy var frcDelegate: TasksFetchedResultsControllerDelegate = {
        return TasksFetchedResultsControllerDelegate(tableView: self.tableView)
    }()
    
    init(coreDataStack stack: CoreDataStack) {
        super.init(nibName: nil, bundle: nil)
        self.stack = stack
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "myCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TaskTableViewController.showCreateNewTaskController))
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func showCreateNewTaskController(sender: UIBarButtonItem) {
        let createVC = CreateNewTaskViewController(coreDataStack: stack)
        showViewController(UINavigationController(rootViewController: createVC), sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return fetchedResultsController.sections?[section].objects.count ?? 0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell =  cell as? TableViewCell else { fatalError("Cell is not registered") }
        if let task = fetchedResultsController.getElementForTableView(indexPath) as? Task{
            cell.updateUI(task)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)) as? TableViewCell
            else { fatalError("Cell is not registered") }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let createVC = CreateNewTaskViewController(coreDataStack: stack)
        if let task = fetchedResultsController.getElementForTableView(indexPath) as? Task{
            createVC.task = task
        }
        showViewController(UINavigationController(rootViewController: createVC), sender: self)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        guard let task = fetchedResultsController.getElementForTableView(indexPath) as? Task else { fatalError("Don't get task from fetchedResultsController") }
        let nameAction = (task.mark) ? "Unmarked" : "Marked"
        
        let checkAction = UITableViewRowAction(style: .Normal, title: nameAction) { [unowned self, task](action, indexPath) in
            task.mark = !task.mark
            self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        checkAction.backgroundColor = UIColor.greenColor()
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") {[unowned self,task] (action, indexPath) in
            let alert = UIAlertController(title: "Warning", message: "Do you want delete task?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive,
                handler: { (UIAlertAction) -> Void in
                self.stack.mainQueueContext.deleteObject(task)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction,checkAction]
    }
}

extension FetchedResultsController{
    func getElementForTableView(indexPath: NSIndexPath) -> NSManagedObject{
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        return sections[indexPath.section].objects[indexPath.row]
    }
}

class TasksFetchedResultsControllerDelegate: FetchedResultsControllerDelegate {
    
    private weak var tableView: UITableView?
    
    // MARK: - Lifecycle FetchedResultsController
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func fetchedResultsControllerDidPerformFetch(controller: FetchedResultsController<Task>) {
        tableView?.reloadData()
    }
    
    func fetchedResultsControllerWillChangeContent(controller: FetchedResultsController<Task>) {
        tableView?.beginUpdates()
    }
    
    func fetchedResultsControllerDidChangeContent(controller: FetchedResultsController<Task>) {
        tableView?.endUpdates()
    }
    
    func fetchedResultsController(controller: FetchedResultsController<Task>,
                                  didChangeObject change: FetchedResultsObjectChange<Task>) {
        switch change {
        case let .Insert(_, indexPath):
            tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case let .Delete(_, indexPath):
            tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case let .Move(_, fromIndexPath, toIndexPath):
            tableView?.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
            
        case let .Update(_, indexPath):
            tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func fetchedResultsController(controller: FetchedResultsController<Task>,
                                  didChangeSection change: FetchedResultsSectionChange<Task>) {
        switch change {
        case let .Insert(_, index):
            tableView?.insertSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
            
        case let .Delete(_, index):
            tableView?.deleteSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
        }
    }
}
