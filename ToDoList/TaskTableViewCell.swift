//
//  TableViewCell.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stikerView: UIView!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateUI(task: Task){
        if task.mark {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.name)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            nameLabel.attributedText = attributeString
        }else{
            nameLabel.text = task.name
        }
         
        let importance = Importances.getImportance(priority: task.priority)
        stikerView.backgroundColor = UIColor(CIColor: CIColor(string: importance.color))
     
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let hour = dateFormatter.stringFromDate(task.date)
        dateFormatter.dateFormat = "dd MMM"
        let date = dateFormatter.stringFromDate(task.date)
        hourLabel.text = hour
        dateLabel.text = date
    }
}
