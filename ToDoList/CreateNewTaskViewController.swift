//
//  CreateNewTaskViewController.swift
//  ToDoList
//
//  Created by developer on 22.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class CreateNewTaskViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate{
    
    var task:Task?

    let importanceArray = Importance.allValue
    var isEditTask: Bool = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var importanceTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var markSegmentedControl: UISegmentedControl!
    
    var dataPiker = UIDatePicker()
    var importancePiker: UIPickerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.enabled = false
        importancePiker = UIPickerView()
        importancePiker!.delegate = self
        if task != nil {
            updateUI()
        }
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwideTask" {
            print("Done")
            if nameTextField.text?.characters.count > 0{
                let name = nameTextField.text
                let date: NSDate? = (dateTextField.text?.characters.count > 0) ? dataPiker.date : nil
                let importance: Importance? = (importanceTextField.text?.characters.count > 0) ? Importance(rawValue: importanceTextField.text!) : nil
                
                let selectMarkIndex = markSegmentedControl.selectedSegmentIndex
                let mark = (selectMarkIndex == 0 ) ? false : true
                
                task = Task(name: name!, date: date, importance: importance,mark: mark)
            }
        }
    }
    
    // MARK: - TextFiend Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == dateTextField{
            textField.inputView = dataPiker
            dataPiker.addTarget(self, action: "datePikerChanged:", forControlEvents: .ValueChanged)
        }else if textField == importanceTextField{
            textField.inputView = importancePiker
        }else if textField == nameTextField{
            print("Text")
            textField.addTarget(self, action: "nameTextChanged:", forControlEvents: .EditingChanged)
        }
    }
    
    func datePikerChanged(sender:UIDatePicker){
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        dateTextField.text = formatter.stringFromDate(sender.date)
    }
    
    func nameTextChanged(sender:UITextField){
        doneButton.enabled = (sender.text?.characters.count > 0) ? true : false
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        importanceTextField.text = importanceArray[row]
    }
    
    // MARK: - Helper
    
    func updateUI(){
        self.title = "Edit task"
        
        nameTextField.text = task?.name
        if task?.date != nil{
            let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            dateTextField.text = formatter.stringFromDate(task!.date!)
            dataPiker.date = (task?.date)!
        }
        
        if task?.importance != nil{
            importanceTextField.text = task?.importance?.rawValue
        }
        
        doneButton.enabled = true
        isEditTask = true
        markSegmentedControl.selectedSegmentIndex = task!.mark ? 1 : 0
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyborad()
    }
    func closeKeyborad(){
        self.view.endEditing(true)
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
