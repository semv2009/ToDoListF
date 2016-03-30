//
//  TaskTableViewController.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Table view data source
    
    private struct StoreBoard{
        static let TableCellIdentifier = "TaskCell"
        static let EditTaskSegue = "EditTask"
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskManager.sharedInstance.tasks?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(StoreBoard.TableCellIdentifier, forIndexPath: indexPath) as? TaskTableViewCell else { fatalError("Can't create cell") }
        cell.task = TaskManager.sharedInstance.tasks![indexPath.row]
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
                TaskManager.sharedInstance.removeTask(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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
                guard let indexpath = tableView.indexPathForSelectedRow else { fatalError("Cat't get indexPathForSelectedRow") }
                TaskManager.sharedInstance.saveTask(task, index: indexpath.row)
            }else{
                TaskManager.sharedInstance.addTask(task)
            }
            tableView.reloadData()
        }
    }

}
