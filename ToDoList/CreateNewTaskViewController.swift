//
//  CreateNewTaskViewController.swift
//  ToDoList
//
//  Created by developer on 22.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class CreateNewTaskViewController: UIViewController{
    var stack: CoreDataStack!

    var task:Task?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var importanceTextField: UITextField!
    @IBOutlet weak var markSegmentedControl: UISegmentedControl!
    
    var doneButton: UIBarButtonItem!
    var datePiсker = UIDatePicker()
    var importancePiсker = UIPickerView()
    
    var importanceArray: [Importance] = Importances.allImportance
    
    init(coreDataStack stack: CoreDataStack) {
        super.init(nibName: nil, bundle: nil)
        self.stack = stack
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtons()
        configureTextFields()
        updateUI()
    }
    
    // MARK: Navigator
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func done() {
        let moc = stack.mainQueueContext
        if let _ = self.task{} else{
            self.task = Task(managedObjectContext: moc)
        }
        
        guard let text = nameTextField.text else { fatalError("Don't have text") }
        self.task?.name = text
        self.task?.date = datePiсker.date
        self.task?.priority = importanceArray[importancePiсker.selectedRowInComponent(0)].priority
        self.task?.mark = markSegmentedControl.selectedSegmentIndex == 0 ? false : true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIHelper
    
    
    func updateUI(){
        if let task = self.task {
            self.title = "Edit task"
            nameTextField.text = task.name
            
            dateTextField.text = task.date.getDateForTextField()
            datePiсker.date = task.date
            
            importanceTextField.text = Importances.getImportance(priority: task.priority).name
            importancePiсker.selectRow(task.priority, inComponent: 0, animated: false)
            
            doneButton.enabled = true
            markSegmentedControl.selectedSegmentIndex = task.mark ? 1 : 0
            nameTextField.becomeFirstResponder()
        }else{
            self.title = "Create task"
            datePiсker.date = NSDate()
            dateTextField.text = datePiсker.date.getDateForTextField()
            
            importanceTextField.text = importanceArray[0].name
            importancePiсker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    func configureTextFields(){
        dateTextField.delegate = self
        dateTextField.inputView = datePiсker
        datePiсker.addTarget(self, action: #selector(CreateNewTaskViewController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
        
        importanceTextField.delegate = self
        importancePiсker.delegate = self
        importanceTextField.inputView = importancePiсker
        
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(CreateNewTaskViewController.nameTextChanged(_:)), forControlEvents: .EditingChanged)
    }
    
    func createBarButtons(){
        doneButton =  UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(CreateNewTaskViewController.done))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(CreateNewTaskViewController.dismiss))
        doneButton.enabled = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyboard()
    }
    
    func closeKeyboard(){
        self.view.endEditing(true)
    }
}

// MARK: - TextField Delegate

extension CreateNewTaskViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            dateTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    func datePickerChanged(sender:UIDatePicker){
        dateTextField.text = sender.date.getDateForTextField()
    }
    
    func nameTextChanged(sender:UITextField){
        doneButton.enabled = (sender.text?.characters.count > 0) ? true : false
    }
}

// MARK: - PickerView Delegate

extension CreateNewTaskViewController: UIPickerViewDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return importanceArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return importanceArray[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        importanceTextField.text = importanceArray[row].name
    }
}

// MARK: - NSDate Extension

extension NSDate{
    func getDateForTextField() -> String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        return formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate))
    }
}