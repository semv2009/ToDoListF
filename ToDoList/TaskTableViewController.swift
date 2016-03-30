//
//  TaskTableViewController.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class TaskTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Task")
        
        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Initialize Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    
    // MARK: - Table view data source
    
    private struct StoreBoard{
        static let TableCellIdentifier = "TaskCell"
        static let EditTaskSegue = "EditTask"
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(StoreBoard.TableCellIdentifier, forIndexPath: indexPath) as? TaskTableViewCell else { fatalError("Can't create cell") }
        // Configure Table View Cell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let nameAction = (TaskManager.sharedInstance.getTask(indexPath.row).mark) ? "Unmarked" : "Marked"
        let checkAction = UITableViewRowAction(style: .Normal, title: nameAction) { (action, indexPath) in
            let task = TaskManager.sharedInstance.getTask(indexPath.row)
            task.mark = !task.mark
            TaskManager.sharedInstance.saveTask(task, index: indexPath.row)
            let range = NSMakeRange(0, self.tableView.numberOfSections)
            let sections = NSIndexSet(indexesInRange: range)
            self.tableView.reloadSections(sections, withRowAnimation: .Automatic)
        }
        checkAction.backgroundColor = UIColor.greenColor()
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") {[unowned self] (action, indexPath) in
            let alert = UIAlertController(title: "Warning", message: "Do you want delete task?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
                self.managedObjectContext.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
                //TaskManager.sharedInstance.removeTask(indexPath.row)
                //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
                cnt.task = cell.task
            }
        }
    }
    
    @IBAction func unwideTask(segue:UIStoryboardSegue){
        if let ctc = segue.sourceViewController as? CreateNewTaskViewController, task = ctc.task{
            if(ctc.isEditTask){
                guard let indexpPath = tableView.indexPathForSelectedRow else { fatalError("Cat't get indexPathForSelectedRow") }
                TaskManager.sharedInstance.saveTask(task, index: indexpPath.row)
            }else{
                TaskManager.sharedInstance.addTask(task)
            }
            tableView.reloadData()
        }
    }
    
    // MARK: Fetched Results Controller Delegate Methods
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRowAtIndexPath(indexPath) as! TaskTableViewCell
                configureCell(cell, atIndexPath: indexPath)
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    func configureCell(cell: TaskTableViewCell, atIndexPath indexPath: NSIndexPath) {
        // Fetch Record
        let record = fetchedResultsController.objectAtIndexPath(indexPath)
        
        // Update Cell
        if let name = record.valueForKey("name") as? String {
            cell.nameLabel.text = name
        }
    }


}
