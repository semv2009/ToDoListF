//
//  CreateTaskViewController.swift
//  ToDoList
//
//  Created by developer on 12.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController,UIPickerViewDelegate{

    var task:Task?
    let importanceArray = Importance.allValue
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var dataPiker: UIDatePicker!
    
    @IBOutlet weak var importancePiker: UIPickerView!{
        didSet{
            importancePiker.delegate = self
        }
    }

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBAction func back(sender: UIBarButtonItem) {
      //self.navigationController?.popViewControllerAnimated(true)
        print("Hy")
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // doneButton.enabled = false
        // Add rounded corners
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwideTask" {
            //if nameLabel.text?.characters.count != 0{
                let name = nameLabel.text!
           // }
            //if descriptionLabel.text?.characters.count != 0{
                let description = descriptionLabel.text!
            //}
            let importance = importanceArray[importancePiker.selectedRowInComponent(0)]
            
            print(importance)
            //task = Task(name: name, descriptionTask: description, date: dataPiker.date, importance: Importance(rawValue: importance) ?? .Usually)
        }
        
    }
    
    // MARK: - Piker View
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return importanceArray.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
        return importanceArray[row]
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
