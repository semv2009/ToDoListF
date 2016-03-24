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
        return (ManagerTask.sharedInstance().tasks?.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoreBoard.TableCellIdentifier, forIndexPath: indexPath) as! TaskTableViewCell
        cell.task = ManagerTask.sharedInstance().tasks![indexPath.row]
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         
        return true
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let nameAction = (ManagerTask.sharedInstance().getTask(indexPath.row).mark) ? "UnResolve" : "Resolve"
        let checkAction = UITableViewRowAction(style: .Normal, title: nameAction) { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TaskTableViewCell
            ManagerTask.sharedInstance().getTask(indexPath.row).mark = !ManagerTask.sharedInstance().getTask(indexPath.row).mark
            let task = ManagerTask.sharedInstance().getTask(indexPath.row)
            ManagerTask.sharedInstance().saveTask(task, index: indexPath.row)
            cell.mark = task.mark
            tableView.reloadData()
        }
        checkAction.backgroundColor = UIColor.greenColor()
        
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            let alert = UIAlertController(title: "Warning", message: "Do you want delete task?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
                ManagerTask.sharedInstance().removeTask(indexPath.row)
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
            if let cell = sender as? TaskTableViewCell{
                if let cnt = segue.destinationViewController as? CreateNewTaskViewController{
                    cnt.task = cell.task
                }
            }
        }
    }
    
    @IBAction func unwideTask(segue:UIStoryboardSegue){
        if let ctc = segue.sourceViewController as? CreateNewTaskViewController{
            let task = ctc.task!
            if(ctc.isEditTask){
                ManagerTask.sharedInstance().saveTask(task, index: (tableView.indexPathForSelectedRow?.row)!)
            }else{
                ManagerTask.sharedInstance().addTask(task)
            }
            tableView.reloadData()
        }
    }

}
