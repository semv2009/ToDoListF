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
    
    @IBAction func unwideTask(segue:UIStoryboardSegue){
//        if let ctc = segue.sourceViewController as? CreateTaskViewController{
//            let newTask = ctc.task!
//            ManagerTask.sharedInstance().addTask(newTask)
//            tableView.reloadData()
//            print(newTask)
//        }
    }
    
    // MARK: - Table view data source
    
    private struct StoreBoard{
        static let TableCellIdentifier = "TaskCell"
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


    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = UIAlertController(title: "Предупреждение", message: "Вы уверены,что хотите удалить задачу?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Удалить", style: UIAlertActionStyle.Destructive, handler: { (UIAlertAction) -> Void in
                ManagerTask.sharedInstance().removeTask(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
