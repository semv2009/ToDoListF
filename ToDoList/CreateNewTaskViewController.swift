//
//  CreateNewTaskViewController.swift
//  ToDoList
//
//  Created by developer on 22.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class CreateNewTaskViewController: UIViewController{
    
    var task:Task?
    let importanceArray = Importance.allValue
    var isEditTask: Bool = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var importanceTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var markSegmentedControl: UISegmentedControl!
    
    var dataPiker = UIDatePicker()
    var importancePiker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.enabled = false
        importancePiker.delegate = self
        if let _ = self.task {
            updateUI()
        }
    }
    
    // MARK: Navigator
    
    private struct StoreBoard{
        static let BackSegue = "unwideTask"
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == StoreBoard.BackSegue {
            if nameTextField.text?.characters.count > 0{
                let name = nameTextField.text
                let date: NSDate? = (dateTextField.text?.characters.count > 0) ? dataPiker.date : nil
                let importance: Importance? = (importanceTextField.text?.characters.count > 0) ? Importance(rawValue: importanceTextField.text ?? "") : nil
                
                let selectMarkIndex = markSegmentedControl.selectedSegmentIndex
                let mark = (selectMarkIndex == 0 ) ? false : true
                
                task = Task(name: name!, date: date, importance: importance,mark: mark)
            }
        }
    }
    
    // MARK: - TextFiend Delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField{
            case dateTextField:
                textField.inputView = dataPiker
                dataPiker.addTarget(self, action: "datePikerChanged:", forControlEvents: .ValueChanged)
            case importanceTextField: textField.inputView = importancePiker
            case nameTextField: textField.addTarget(self, action: "nameTextChanged:", forControlEvents: .EditingChanged)
            default: break
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
    
    // MARK: - Helper
    
    func updateUI(){
        self.title = "Edit task"
        guard let task = self.task else { fatalError("Task is nil") }
        nameTextField.text = task.name
        if let date = task.date{
            let formatter = NSDateFormatter()
            formatter.dateStyle = .FullStyle
            dateTextField.text = formatter.stringFromDate(date)
            dataPiker.date = date
        }
        
        if let importance = task.importance{
            importanceTextField.text = importance.rawValue
        }
        
        doneButton.enabled = true
        isEditTask = true
        markSegmentedControl.selectedSegmentIndex = task.orderMark
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyborad()
    }
    
    func closeKeyborad(){
        self.view.endEditing(true)
    }

}

// MARK: - Piker View
extension CreateNewTaskViewController: UIPickerViewDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        return importanceArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return importanceArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        importanceTextField.text = importanceArray[row]
    }
    
}
