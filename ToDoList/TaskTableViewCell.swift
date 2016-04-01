//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var task: Task?{
        didSet{
            updateUI()
        }
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stikerView: UIView!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateUI(){
        guard let task = self.task else{ fatalError("Task is empty") }

        if task.mark {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.name)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            nameLabel.attributedText = attributeString
        }else{
            nameLabel.text = task.name
        }
        
        if let importance = task.importances{
            stikerView.backgroundColor = UIColor(CIColor: CIColor(string: importance.color))
        }
        
        if let date = task.date{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            let hour = dateFormatter.stringFromDate(date)
            dateFormatter.dateFormat = "dd MMM"
            let date = dateFormatter.stringFromDate(date)
            hourLabel.text = hour
            dateLabel.text = date
        }else{
            hourLabel.text = ""
            dateLabel.text = ""
        }
    }
    
}
