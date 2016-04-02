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

class TaskTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var stack: CoreDataStack!{
        didSet{
            print("Stack set")
        }
    }
    
    var str: String?{
        didSet{
            print(str)
        }
    }
    private lazy var fetchedResultsController: FetchedResultsController<Task> = {
        let fetchRequest = NSFetchRequest(entityName: Task.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "importances.priority", ascending: true)]
        let frc = FetchedResultsController<Task>(fetchRequest: fetchRequest,
                                                 managedObjectContext: self.stack.mainQueueContext,
                                                 sectionNameKeyPath: nil)
        frc.setDelegate(self.frcDelegate)
        return frc
    }()
    private lazy var frcDelegate: TasksFetchedResultsControllerDelegate = {
        return TasksFetchedResultsControllerDelegate(tableView: self.tableView)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func showCreateNewTaskController(sender: UIBarButtonItem) {
         let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createVC = CreateNewTaskViewController(coreDataStack: stack)
        showViewController( UINavigationController(rootViewController: createVC), sender: self)
    }
    // MARK: - Table view data source
    
    private struct StoreBoard{
        static let TableCellIdentifier = "TaskCell"
        static let EditTaskSegue = "EditTask"
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print(fetchedResultsController.sections?.count)
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(fetchedResultsController.sections?[section].objects.count)
       return fetchedResultsController.sections?[section].objects.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(StoreBoard.TableCellIdentifier, forIndexPath: indexPath) as? TaskTableViewCell else { fatalError("Can't create cell") }
        if let task = fetchedResultsController.getElementForTableView(indexPath) as? Task{
            cell.task = task
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        guard let task = fetchedResultsController.getElementForTableView(indexPath) as? Task else { fatalError("Don't get task from fetchedResultsController") }
        let nameAction = (task.mark) ? "Unmarked" : "Marked"
        
        let checkAction = UITableViewRowAction(style: .Normal, title: nameAction) { [unowned self](action, indexPath) in
            guard let task = self.fetchedResultsController.getElementForTableView(indexPath) as? Task  else { fatalError("Don't get task from fetchedResultsController") }
            task.mark = !task.mark
        }
        checkAction.backgroundColor = UIColor.greenColor()
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") {[unowned self] (action, indexPath) in
            let alert = UIAlertController(title: "Warning", message: "Do you want delete task?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive,
                handler: { (UIAlertAction) -> Void in
                guard let task = self.fetchedResultsController.getElementForTableView(indexPath) as? Task else { fatalError("Don't get task from fetchedResultsController") }
                self.stack.mainQueueContext.deleteObject(task)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction,checkAction]
    }
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoreBoard.EditTaskSegue{
            if let cell = sender as? TaskTableViewCell, cnt = segue.destinationViewController as? CreateNewTaskViewController{
               // cnt.task = cell.task
            }
        }
    }
    
    @IBAction func unwideTask(segue:UIStoryboardSegue){
//        if let ctc = segue.sourceViewController as? CreateNewTaskViewController, task = ctc.task{
//            if(ctc.isEditTask){
//                guard let indexpPath = tableView.indexPathForSelectedRow else { fatalError("Cat't get indexPathForSelectedRow") }
//                TaskManager.sharedInstance.saveTask(task, index: indexpPath.row)
//            }else{
//                TaskManager.sharedInstance.addTask(task)
//            }
//            tableView.reloadData()
       // }
    }
    
//    func configureCell(cell: TaskTableViewCell, atIndexPath indexPath: NSIndexPath) {
//        // Fetch Record
//        let record = fetchedResultsController.objectAtIndexPath(indexPath)
//        
//        // Update Cell
//        if let name = record.valueForKey("name") as? String {
//            cell.nameLabel.text = name
//        }
//    }


}
extension FetchedResultsController{
    func getElementForTableView(indexPath: NSIndexPath) -> NSManagedObject{
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        return sections[indexPath.section].objects[indexPath.row]
    }
}
class TasksFetchedResultsControllerDelegate: FetchedResultsControllerDelegate {
    
    private weak var tableView: UITableView?
    
    // MARK: - Lifecycle
    
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
