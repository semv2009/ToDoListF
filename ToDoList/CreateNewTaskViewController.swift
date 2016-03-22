//
//  CreateNewTaskViewController.swift
//  ToDoList
//
//  Created by developer on 22.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class CreateNewTaskViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var importanceTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
    }
    
    func datePikerChanged(sender:UIDatePicker){
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        dateTextField.text = formatter.stringFromDate(sender.date)
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
