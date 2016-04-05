//
//  CreateNewTaskViewController.swift
//  ToDoList
//
//  Created by developer on 22.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class CreateNewTaskViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    var stack: CoreDataStack!{
        didSet{
            print("Stack set'")
        }
    }
    


//    var task:Task?
//    //let importanceArray = Importance.allValue
//    var isEditTask: Bool = false
//    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var importanceTextField: UITextField!
    @IBOutlet weak var markSegmentedControl: UISegmentedControl!
    
    var doneButton: UIBarButtonItem!
    var dataPiker = UIDatePicker()
    var importancePiker = UIPickerView()
    
    var importanceArray: [Importance]?
    var importanceArrays =  ["sd","dsds","cfffd"]
    
    
    init(coreDataStack stack: CoreDataStack) {
        super.init(nibName: nil, bundle: nil)
        self.stack = stack
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Start load")
        guard let stack = stack else {
            assertionFailure("Stack was not setup first")
            return
        }
        let moc = stack.newBackgroundWorkerMOC()
        do {
            try moc.performAndWaitOrThrow {
                self.importanceArray = try Importance.allInContext(moc)
            }
        } catch {
            print("Cannot load importances: \(error)")
        }
        
        guard let importanceArray = self.importanceArray else { fatalError("Don't have mportance") }
        print(importanceArray.count)
        for i in 0...importanceArray.count-1 {
            print(importanceArray[i].name)
        }
        
        doneButton =  UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(CreateNewTaskViewController.dismiss))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(CreateNewTaskViewController.dismiss))
        
        doneButton.enabled = false
        nameTextField.delegate = self
        dateTextField.delegate = self
        importanceTextField.delegate = self
        importancePiker.delegate = self
        importancePiker.dataSource = self
//        if let _ = self.task {
//            updateUI()
//        }
    }
    @objc private func dismiss() {
        print("Exit")
        dismissViewControllerAnimated(true, completion: nil)
    }
//
//    // MARK: Navigator
//    
//    private struct StoreBoard{
//        static let BackSegue = "unwideTask"
//    }
//
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == StoreBoard.BackSegue {
//            if nameTextField.text?.characters.count > 0{
//                let name = nameTextField.text
//                let date: NSDate? = (dateTextField.text?.characters.count > 0) ? dataPiker.date : nil
//                let importance: Importance? = (importanceTextField.text?.characters.count > 0) ? Importance(rawValue: importanceTextField.text ?? "") : nil
//                
//                let selectMarkIndex = markSegmentedControl.selectedSegmentIndex
//                let mark = (selectMarkIndex == 0 ) ? false : true
//                
//                task = Task(name: name!, date: date, importance: importance,mark: mark)
//            }
//        }
//    }
//    
    
    // MARK: - TextFiend Delegate
 
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField{
            case dateTextField:
                textField.inputView = dataPiker
                dataPiker.addTarget(self, action: #selector(CreateNewTaskViewController.datePikerChanged(_:)), forControlEvents: .ValueChanged)
            case importanceTextField: textField.inputView = importancePiker
            case nameTextField: textField.addTarget(self, action: #selector(CreateNewTaskViewController.nameTextChanged(_:)), forControlEvents: .EditingChanged)
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
//
//    // MARK: - Helper
//    
//    func updateUI(){
//        self.title = "Edit task"
//        guard let task = self.task else { fatalError("Task is nil") }
//        nameTextField.text = task.name
//        if let date = task.date{
//            let formatter = NSDateFormatter()
//            formatter.dateStyle = .FullStyle
//            dateTextField.text = formatter.stringFromDate(date)
//            dataPiker.date = date
//        }
//        
//        if let importance = task.importance{
//            importanceTextField.text = importance.rawValue
//        }
//        
//        doneButton.enabled = true
//        isEditTask = true
//        markSegmentedControl.selectedSegmentIndex = task.orderMark
//    }
//    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKeyborad()
    }
    
    func closeKeyborad(){
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        guard let importanceArray = importanceArray else { fatalError("Don't have mportance") }
        print(importanceArray.count)
        return importanceArrays.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        guard let importanceArray = importanceArray else { fatalError("Don't have mportance") }
        print("Row = \(row)")
        return importanceArrays[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let importanceArray = importanceArray else { fatalError("Don't have mportance") }
        importanceTextField.text = importanceArrays[row]
    }

//
}
//
