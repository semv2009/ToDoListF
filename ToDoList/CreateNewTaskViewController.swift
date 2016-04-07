//
//  CreateNewTaskViewController.swift
//  ToDoList
//
//  Created by developer on 22.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class CreateNewTaskViewController: UIViewController,UITextFieldDelegate{
    var stack: CoreDataStack!

    var task:Task?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var importanceTextField: UITextField!
    @IBOutlet weak var markSegmentedControl: UISegmentedControl!
    
    var doneButton: UIBarButtonItem!
    var datePiсker = UIDatePicker()
    var importancePiсker = UIPickerView()
    
    var importanceArray: [Importance]?
    var importanceNames: [String]?
    
    
    init(coreDataStack stack: CoreDataStack) {
        super.init(nibName: nil, bundle: nil)
        self.stack = stack
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let stack = stack else {
            assertionFailure("Stack was not setup first")
            return
        }
        let moc = stack.mainQueueContext
        do {
            try moc.performAndWaitOrThrow {
                let fetchRequest = Importance.fetchRequestForEntity(inContext: moc)
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false)]
                self.importanceArray = try moc.executeFetchRequest(fetchRequest) as? [Importance]
            }
        } catch {
            print("Cannot load importances: \(error)")
        }
        
        guard let importanceArray = self.importanceArray else { fatalError("Don't have importance") }
        importanceNames = importanceArray.map({$0.name})
        
        doneButton =  UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(CreateNewTaskViewController.done))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(CreateNewTaskViewController.dismiss))
        doneButton.enabled = false
        
        nameTextField.delegate = self
        dateTextField.delegate = self
        importanceTextField.delegate = self
        importancePiсker.delegate = self
        
        updateUI()
    }
    
    // MARK: Navigator
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @objc private func done() {
        guard let importanceArray = importanceArray else { fatalError("Don't have importance") }
        let moc = stack.mainQueueContext
        if let _ = self.task{} else{
            self.task = Task(managedObjectContext: moc)
        }
        
        self.task?.name = nameTextField.text!
        self.task?.date = datePiсker.date
        self.task?.importances = importanceArray[importancePiсker.selectedRowInComponent(0)]
        self.task?.mark = markSegmentedControl.selectedSegmentIndex == 0 ? false : true
        
        do {
            try moc.performAndWaitOrThrow {
                try moc.saveContextAndWait()
            }
        } catch {
            print("Error creating inital data: \(error)")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TextFiend Delegate
 
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            dateTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField{
            case dateTextField:
                textField.inputView = datePiсker
                datePiсker.addTarget(self, action: #selector(CreateNewTaskViewController.datePikerChanged(_:)), forControlEvents: .ValueChanged)
            case importanceTextField: textField.inputView = importancePiсker
            case nameTextField: textField.addTarget(self, action: #selector(CreateNewTaskViewController.nameTextChanged(_:)), forControlEvents: .EditingChanged)
            default: break
        }
    }

    func datePikerChanged(sender:UIDatePicker){
        dateTextField.text = sender.date.getDateForTextField()
    }

    func nameTextChanged(sender:UITextField){
        doneButton.enabled = (sender.text?.characters.count > 0) ? true : false
    }
    

    // MARK: - Helper
    
    func updateUI(){
        if let task = self.task {
            self.title = "Edit task"
            nameTextField.text = task.name
            if let date = task.date{
                dateTextField.text = date.getDateForTextField()
                datePiсker.date = date
            }
            
            if let importances = task.importances, let importanceArray = importanceArray {
                let indexImportance  = importanceArray.count - 1 - importances.priority.integerValue
                importanceTextField.text = importanceArray[indexImportance].name
                importancePiсker.selectRow(indexImportance, inComponent: 0, animated: false)
            }
            
            doneButton.enabled = true
            markSegmentedControl.selectedSegmentIndex = task.mark ? 1 : 0
        }else{
            self.title = "Create task"
            datePiсker.date = NSDate()
            dateTextField.text = datePiсker.date.getDateForTextField()
            
            if let importanceArray = importanceArray {
                importanceTextField.text = importanceArray[0].name
                importancePiсker.selectRow(0, inComponent: 0, animated: false)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyborad()
    }
    
    func closeKeyborad(){
        self.view.endEditing(true)
    }
}

// MARK: - PickerView Delegate

extension CreateNewTaskViewController: UIPickerViewDelegate{
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        guard let importanceNames = importanceNames else { fatalError("Don't have mportance") }
        return importanceNames.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        guard let importanceNames = importanceNames else { fatalError("Don't have mportance") }
        return importanceNames[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let importanceNames = importanceNames else { fatalError("Don't have task...") }
        importanceTextField.text = importanceNames[row]
    }
}
extension NSDate{
    func getDateForTextField() -> String{
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        return formatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate))
    }
}