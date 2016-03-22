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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var importanceTextField: UITextField!
    
    var importancePiker: UIPickerView{
        didSet{
            importancePiker.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
            task = Task(name: name, descriptionTask: description, date: dataPiker.date, importance: Importance(rawValue: importance) ?? .Usually)
        }
    }
    
    // MARK: - TextFiend Delegate
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == dateTextField{
            let dataPiker = UIDatePicker()
            textField.inputView = dataPiker
            dataPiker.addTarget(self, action: "datePikerChanged:", forControlEvents: .ValueChanged)
        }else if textField == importanceTextField{
            textField.inputView = importancePiker
            importancePiker.addTarget(self, action: "importancePikerChanged:", forControlEvents: .ValueChanged)
        }
    }
    
    func datePikerChanged(sender:UIDatePicker){
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        dateTextField.text = formatter.stringFromDate(sender.date)
    }
    
    func importancePikerChanged(sender:UIPickerView){
        importanceTextField.text = importanceArray[sender.selectedRowInComponent(0)]
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
